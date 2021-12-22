import { Instance as Popper, createPopper, Placement } from "@popperjs/core";
import { createElement, getHTML } from "./util";

export interface PopoverOptions {
  id?: string;
  url: string;
  selector?: HTMLElement | string;
  placement?: Placement;
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

  async open({ url, selector, placement }: PopoverOptions): Promise<void> {
    const root =
      typeof selector === "string"
        ? document.querySelector(selector)
        : selector;
    if (!root) {
      return;
    }
    const popoverDiv = createElement(document.body, "popover");
    const arrow = createElement(popoverDiv, "popover__arrow");
    arrow.setAttribute("data-popper-arrow", "true");
    const content = createElement(popoverDiv, "popover__content");
    content.innerHTML = await getHTML(url);
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
