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
