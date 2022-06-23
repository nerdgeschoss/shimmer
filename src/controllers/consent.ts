import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["check"];
  declare checkTargets: HTMLInputElement[];

  connect(): void {
    this.checkTargets.forEach((input) => {
      input.checked =
        window.ui?.consent.permitted.includes(input.name) ?? false;
    });
  }

  permitAll(event: Event): void {
    event.preventDefault();
    window.ui?.consent.permitAll();
    this.element.remove();
  }

  save(event: Event): void {
    event.preventDefault();
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    window.ui!.consent.permitted = this.checkTargets
      .filter((e) => e.checked)
      .map((e) => e.name);
    (this.element as HTMLDivElement).hidden = true;
  }
}
