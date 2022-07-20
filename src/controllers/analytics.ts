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

window.gtag = (...arg) => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  dataLayer.push(arg as any);
};
window.gtag("js", new Date());

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
