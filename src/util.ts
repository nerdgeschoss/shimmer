import { get } from "@rails/request.js";

export async function getHTML(url: string): Promise<string> {
  const response = await get(url, { headers: { "X-Shimmer": "true" } });
  if (response.ok) {
    return await response.response.text();
  }
  return "";
}

export const loaded: Promise<void> = new Promise((res) => {
  document.addEventListener("DOMContentLoaded", () => {
    res();
  });
});

export async function nextFrame(): Promise<void> {
  return new Promise((res) => {
    setTimeout(res, 10);
  });
}

export function createElement(
  parent: HTMLElement,
  className: string
): HTMLDivElement {
  const element = document.createElement("div");
  element.className = className;
  parent.append(element);
  return element;
}

export function guid(): string {
  function s4(): string {
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1);
  }
  return [s4() + s4(), s4(), s4(), s4(), s4() + s4() + s4()].join("-");
}

export function wait(seconds: number): Promise<void> {
  return new Promise((res) => {
    setTimeout(res, seconds * 1000);
  });
}
