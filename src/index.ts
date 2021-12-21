import { ModalPresenter } from "./modal";

export const ui = {
  modal: new ModalPresenter(),
};

declare global {
  interface Window {
    ui: typeof ui;
  }
}

window.ui = ui;
