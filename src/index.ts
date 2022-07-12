import type { Application } from "@hotwired/stimulus";
import { ModalPresenter } from "./modal";
import { PopoverPresenter } from "./popover";
import { Consent } from "./consent";
import RemoteNavigationController from "./controllers/remote-navigation";
import ConsentController from "./controllers/consent";
import "./touch";

export { registerServiceWorker } from "./serviceworker";
export { currentLocale } from "./locale";

declare global {
  interface Window {
    ui?: {
      modal: ModalPresenter;
      popover: PopoverPresenter;
      consent: Consent;
    };
  }
}

function createRemoteDestination(): void {
  if (document.getElementById("shimmer")) {
    return;
  }
  const root = document.createElement("div");
  root.id = "shimmer";
  document.body.append(root);
}

export async function start({
  application,
}: {
  application: Application;
}): Promise<void> {
  window.addEventListener("turbo:load", createRemoteDestination);
  createRemoteDestination();
  application.register("remote-navigation", RemoteNavigationController);
  application.register("consent", ConsentController);
  window.ui = {
    modal: new ModalPresenter(),
    popover: new PopoverPresenter(),
    consent: new Consent(),
  };
}
