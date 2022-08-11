import { getCookie, setCookie } from "./util";

const consentCategories = ["essential", "targeting", "statistic"] as const;
export type ConsentCategory = typeof consentCategories[number];

export class Consent {
  #consentListeners: Record<ConsentCategory, Array<() => void>> = {
    essential: [],
    targeting: [],
    statistic: [],
  };

  get permitted(): ConsentCategory[] {
    return (getCookie("consent") ?? "").split(",") as ConsentCategory[];
  }

  set permitted(settings: ConsentCategory[]) {
    setCookie("consent", settings.join(","));
    settings.forEach((category) => {
      this.#consentListeners[category].forEach((e) => e());
    });
  }

  get given(): boolean {
    return getCookie("consent") !== undefined;
  }

  permitAll(): void {
    this.permitted = consentCategories.slice();
  }

  denyAll(): void {
    this.permitted = ["essential"];
  }

  showSettings(): void {
    const element = document.getElementById("personalization-settings");
    if (element) element.hidden = false;
  }

  consentFor(category: ConsentCategory): Promise<void> {
    return new Promise((res) => {
      if (this.permitted.includes(category)) {
        res();
      } else {
        this.#consentListeners[category].push(res);
      }
    });
  }

  async enableGoogleAnalytics(
    id: string,
    role: ConsentCategory = "statistic"
  ): Promise<void> {
    await this.consentFor(role);
    window.gtag("js", new Date());
    window.gtag("config", id);
    const script = document.createElement("script");
    script.async = true;
    script.setAttribute(
      "src",
      `https://www.googletagmanager.com/gtag/js?id=${id}`
    );
    document.head.prepend(script);
  }
}
