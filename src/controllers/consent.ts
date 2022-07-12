import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["check"];
  declare checkTargets: HTMLInputElement[];

  connect(): void {
    this.checkTargets.forEach((input) => {
      input.checked =
        window.ui?.consent.permitted.includes(input.name) ||
        input.name === "essential";
    });
  }

  permitAll(event: Event): void {
    event.preventDefault();
    window.ui?.consent.permitAll();
    this.closeAll();
  }

  denyAll(event: Event): void {
    event.preventDefault();
    window.ui?.consent.denyAll();
    this.closeAll();
  }

  save(event: Event): void {
    event.preventDefault();
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    window.ui!.consent.permitted = this.checkTargets
      .filter((e) => e.checked)
      .map((e) => e.name);
    this.closeAll();
  }

  manage(event: Event): void {
    event.preventDefault();
    const div = document.body.querySelector(
      "#personalization-settings"
    ) as HTMLDivElement;
    if (!div) return;
    (this.element as HTMLElement).hidden = true;
    div.hidden = false;
  }

  closeAll(): void {
    document
      .querySelectorAll("[data-controller='consent']")
      .forEach((e: HTMLElement) => (e.hidden = true));
  }
}
