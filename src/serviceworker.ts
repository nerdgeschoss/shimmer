export async function registerServiceWorker(): Promise<void> {
  if (navigator.serviceWorker) {
    await navigator.serviceWorker.register("/serviceworker.js", {
      scope: "./",
    });
  }
}
