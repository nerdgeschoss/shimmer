declare global {
  interface Window {
    ui: typeof ui;
  }
}

import { ModalPresenter } from "./modal";
import "./touch";

export const ui = {
  modal: new ModalPresenter(),
};

window.ui = ui;

export { registerServiceWorker } from "./serviceworker";
export { currentLocale } from "./locale";
