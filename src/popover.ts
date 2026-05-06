import { Instance as Popper, createPopper, Placement } from "@popperjs/core";
import { createElement, getHTML } from "./util";

export interface PopoverOptions {
  id?: string;
  url: string;
  selector?: HTMLElement | string;
  placement?: Placement;
  classname?: string;
}

export class PopoverPresenter {
  private popovers: Record<string, Popover> = {};
  private lastClickedElement?: HTMLElement;

  constructor() {
    document.addEventListener("click", this.trackElement);
  }

  async open(options: PopoverOptions): Promise<void> {
    const id = (options.id = options.id ?? "default-popover");
    options.selector = options.selector ?? this.lastClickedElement;
    (this.popovers[id] = new Popover()).open(options);
  }

  async close({ id }: { id?: string } = {}): Promise<void> {
    let promise: Promise<unknown> | null = null;
    if (id) {
      promise = this.popovers[id]?.close();
      delete this.popovers[id];
    } else {
      promise = Promise.all(Object.values(this.popovers).map((e) => e.close()));
      this.popovers = {};
    }
    await promise;
  }

  private trackElement = (event: MouseEvent): void => {
    this.lastClickedElement = event.target as HTMLElement;
  };
}

export class Popover {
  private popper?: Popper;
  private popoverDiv?: HTMLDivElement;

  async open({
    url,
    selector,
    placement,
    classname,
  }: PopoverOptions): Promise<void> {
    const root =
      typeof selector === "string"
        ? document.querySelector(selector)
        : selector;
    if (!root) {
      return;
    }
    const popoverClassname = ["popover"];
    if (classname) {
      popoverClassname.push(classname);
    }
    const popoverDiv = createElement(document.body, popoverClassname.join(" "));
    const arrow = createElement(popoverDiv, "popover__arrow");
    arrow.setAttribute("data-popper-arrow", "true");
    this.popper = createPopper(root, popoverDiv, {
      placement: placement ?? "auto",
      modifiers: [
        {
          name: "offset",
          options: {
            offset: [0, 8],
          },
        },
      ],
    });
    this.popoverDiv = popoverDiv;
    const content = createElement(popoverDiv, "popover__content");
    createElement(content, "popover__placeholder");
    content.innerHTML = await getHTML(url);
    document.addEventListener("click", this.clickOutside);
  }

  async close(): Promise<void> {
    this.popper?.destroy();
    this.popper = undefined;
    document.removeEventListener("click", this.clickOutside);
    this.popoverDiv?.remove();
    this.popoverDiv = undefined;
  }

  private clickOutside = (event: MouseEvent): void => {
    if (this.popoverDiv?.contains(event.target as HTMLElement)) {
      return;
    }
    event.preventDefault();
    this.close();
  };
}
