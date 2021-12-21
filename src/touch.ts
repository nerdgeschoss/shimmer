document.addEventListener("turbo:load", () => {
  if (window.ontouchstart !== undefined) {
    document.body.classList.add("touch");
  } else {
    document.body.classList.add("no-touch");
  }
});

document.addEventListener("focusin", (event) => {
  const input = event.target as HTMLElement;
  if (input.tagName === "INPUT" || input.tagName === "TEXTAREA") {
    document.body.classList.add("keyboard-visible");
  }
});

document.addEventListener("focusout", () => {
  document.body.classList.remove("keyboard-visible");
});
