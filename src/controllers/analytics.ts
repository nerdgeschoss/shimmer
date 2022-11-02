import { Controller } from "@hotwired/stimulus";

interface DataEvent {
  event: string;
}

declare global {
  interface Window {
    dataLayer?: DataEvent[];
    gtag(...arg): void;
  }
}

const dataLayer = (window.dataLayer = window.dataLayer ?? []);
// eslint-disable-next-line @typescript-eslint/no-unused-vars
function gtag(..._arg): void {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  // eslint-disable-next-line prefer-rest-params
  dataLayer.push(arguments);
}
window.gtag = gtag;

export default class extends Controller {
  connect(): void {
    this.recordPage();
  }

  recordAction(event: MouseEvent): void {
    const data = JSON.parse(
      (event.target as HTMLElement).dataset.analytics ?? "{}"
    );
    const eventName = data["event"];
    delete data["event"];
    gtag("event", eventName, data);
  }

  recordPage(): void {
    gtag("event", "page_view", {
      page_title: document.title,
      page_location: document.location.toString(),
    });
  }
}
