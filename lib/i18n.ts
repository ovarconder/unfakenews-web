export const locales = [
  "th", // Thai
  "en", // English
  "zh", // Chinese
  "ja", // Japanese
  "es", // Spanish
  "fr", // French
  "de", // German
  "ko", // Korean
  "ru", // Russian
  "pt", // Portuguese
  "ar", // Arabic
] as const;

export type Locale = (typeof locales)[number];

export const defaultLocale: Locale = "en";

export const languageNames: Record<Locale, { native: string; english: string }> = {
  th: { native: "ไทย", english: "Thai" },
  en: { native: "English", english: "English" },
  zh: { native: "中文", english: "Chinese" },
  ja: { native: "日本語", english: "Japanese" },
  es: { native: "Español", english: "Spanish" },
  fr: { native: "Français", english: "French" },
  de: { native: "Deutsch", english: "German" },
  ko: { native: "한국어", english: "Korean" },
  ru: { native: "Русский", english: "Russian" },
  pt: { native: "Português", english: "Portuguese" },
  ar: { native: "العربية", english: "Arabic" },
};

export function getLocale(locale?: string): Locale {
  if (locale && locales.includes(locale as Locale)) {
    return locale as Locale;
  }
  return defaultLocale;
}

export function isRTL(locale: Locale): boolean {
  return locale === "ar";
}
