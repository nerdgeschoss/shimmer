import { loaded, createElement, nextFrame, getHTML } from "./util";

export interface ModalOptions {
  id?: string;
  url: string;
  size?: string;
  close?: boolean;
}

export class ModalPresenter {
  private modals: Record<string, Modal> = {};

  constructor() {
    loaded.then(this.prepareBlind);
  }

  async open(options: ModalOptions): Promise<void> {
    const id = (options.id = options.id ?? "default-modal");
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

  private async prepareBlind(): Promise<void> {
    createElement(document.body, "modal-blind");
  }
}

export class Modal {
  private readonly root: HTMLDivElement;
  private readonly frame: HTMLDivElement;
  private readonly closeButton: HTMLDivElement;

  constructor({ presenter, id }: { presenter: ModalPresenter; id: string }) {
    this.root = createElement(document.body, "modal");
    const content = createElement(this.root, "modal__content");
    this.closeButton = createElement(content, "modal__close");
    this.closeButton.addEventListener("click", () => {
      presenter.close({ id });
    });
    this.frame = createElement(content, "modal__frame");
  }

  async open({ size, url, close }: ModalOptions): Promise<void> {
    await nextFrame();
    this.closeButton.style.display = close ?? true ? "block" : "none";
    this.root.classList.add("modal--open");
    this.root.classList.add("modal--loading");
    this.root.classList.toggle("modal--small", size === "small");
    this.frame.innerHTML = await getHTML(url);
  }

  async close(): Promise<void> {
    this.root.classList.remove("modal--open");
  }
}
