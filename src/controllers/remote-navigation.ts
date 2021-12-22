import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect(): void {
    const script = (this.element as HTMLDivElement).innerText;
    (0, eval)(script);
    this.element.remove();
  }
}
