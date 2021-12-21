declare global {
  interface Window {
    ui: typeof ui;
  }
}

import { ModalPresenter } from "./modal";
import "./touch";

const root = document.createElement("div");
root.id = "shimmer";
document.body.append(root);

export const ui = {
  modal: new ModalPresenter(),
};

window.ui = ui;

export { registerServiceWorker } from "./serviceworker";
export { currentLocale } from "./locale";
