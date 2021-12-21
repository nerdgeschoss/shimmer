export function currentLocale(): string {
  return (document.documentElement.lang || "en") as string;
}
