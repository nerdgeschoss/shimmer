declare global {
  interface Window {
    ui?: {
      modal: ModalPresenter;
    };
  }
}

import type { Application } from "@hotwired/stimulus";
import { ModalPresenter } from "./modal";
import RemoteNavigationController from "./controllers/remote-navigation";
import "./touch";

export { registerServiceWorker } from "./serviceworker";
export { currentLocale } from "./locale";

export async function start({
  application,
}: {
  application: Application;
}): Promise<void> {
  const root = document.createElement("div");
  root.id = "shimmer";
  document.body.append(root);
  application.register("remote-navigation", RemoteNavigationController);
  window.ui = {
    modal: new ModalPresenter(),
  };
}
