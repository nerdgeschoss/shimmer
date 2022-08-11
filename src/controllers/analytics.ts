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
function gtag(): void {
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
    dataLayer.push(data);
  }

  recordPage(): void {
    const event = {
      event: "Pageview",
      path: location.pathname + location.search,
      host: location.host,
    };
    dataLayer.push(event);
  }
}
