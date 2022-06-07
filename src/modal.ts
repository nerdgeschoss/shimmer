import { createElement, nextFrame, getHTML, guid, wait } from "./util";

export interface ModalOptions {
  id?: string;
  url: string;
  size?: string;
  close?: boolean;
}

export class ModalPresenter {
  private modals: Record<string, Modal> = {};

  constructor() {
    document.addEventListener("turbo:load", this.prepareBlind);
  }

  async open(options: ModalOptions): Promise<void> {
    const id = (options.id = options.id ?? guid());
    (this.modals[id] = new Modal({ presenter: this, id })).open(options);
    this.updateBlindStatus();
  }

  async close({ id }: { id?: string } = {}): Promise<void> {
    let promise: Promise<unknown> | null = null;
    if (id) {
      promise = this.modals[id]?.close();
      delete this.modals[id];
    } else {
      promise = Promise.all(Object.values(this.modals).map((e) => e.close()));
      this.modals = {};
    }
    this.updateBlindStatus();
    await promise;
  }

  private updateBlindStatus(): void {
    const open = Object.keys(this.modals).length > 0;
    document.body.classList.toggle("modal-open", open);
  }

  private prepareBlind: () => void = () => {
    createElement(document.body, "modal-blind");
  };
}

export class Modal {
  id: string;
  private presenter: ModalPresenter;
  private root?: HTMLDivElement;

  constructor({ presenter, id }: { presenter: ModalPresenter; id: string }) {
    this.presenter = presenter;
    this.id = id;
  }

  async open({ size, url, close }: ModalOptions): Promise<void> {
    const root = createElement(document.body, "modal");
    this.root = root;
    const content = createElement(root, "modal__content");
    const closeButton = createElement(content, "modal__close");
    closeButton.addEventListener("click", () => {
      this.presenter.close({ id: this.id });
    });
    const frame = createElement(content, "modal__frame");
    await nextFrame();
    closeButton.style.display = close ?? true ? "block" : "none";
    root.classList.add("modal--open");
    root.classList.add("modal--loading");
    root.classList.toggle("modal--small", size === "small");
    frame.innerHTML = await getHTML(url);
    root.classList.remove("modal--loading");
  }

  async close(): Promise<void> {
    const root = this.root;
    if (!root) {
      return;
    }
    root.classList.remove("modal--open");
    await wait(1);
    root.remove();
    this.root = undefined;
  }
}
