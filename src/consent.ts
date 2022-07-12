import { getCookie, setCookie } from "./util";

export class Consent {
  get permitted(): string[] {
    return (getCookie("consent") ?? "").split(",");
  }

  set permitted(settings: string[]) {
    setCookie("consent", settings.join(","));
  }

  get given(): boolean {
    return getCookie("consent") !== undefined;
  }

  permitAll(): void {
    this.permitted = ["essential", "targeting", "statistic"];
  }

  denyAll(): void {
    this.permitted = ["essential"];
  }

  showSettings(): void {
    const element = document.getElementById("personalization-settings");
    if (element) element.hidden = false;
  }
}
