"use client";

import { usePathname, useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { useState } from "react";
import { Check, ChevronDown, Languages } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Locale, locales, languageNames, isRTL } from "@/lib/i18n";

interface LanguageSwitcherProps {
  currentLang: Locale;
  currentSlug?: string;
}

export function LanguageSwitcher({ currentLang, currentSlug }: LanguageSwitcherProps) {
  const [isOpen, setIsOpen] = useState(false);
  const router = useRouter();
  const pathname = usePathname();

  const handleLanguageChange = (newLang: Locale) => {
    if (currentSlug) {
      router.push(`/${newLang}/posts/${currentSlug}`);
    } else {
      // For other pages, reconstruct the path with new language
      const segments = pathname.split("/").filter(Boolean);
      segments[0] = newLang;
      router.push(`/${segments.join("/")}`);
    }
    setIsOpen(false);
  };

  return (
    <div className="relative">
      <Button
        variant="outline"
        size="sm"
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 min-w-[140px] justify-between"
      >
        <div className="flex items-center gap-2">
          <Languages className="h-4 w-4" />
          <span className="font-medium">{languageNames[currentLang].native}</span>
        </div>
        <ChevronDown
          className={`h-4 w-4 transition-transform ${isOpen ? "rotate-180" : ""}`}
        />
      </Button>

      <AnimatePresence>
        {isOpen && (
          <>
            {/* Backdrop */}
            <div
              className="fixed inset-0 z-40"
              onClick={() => setIsOpen(false)}
            />

            {/* Dropdown */}
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.2 }}
              className="absolute right-0 mt-2 w-56 bg-background border rounded-lg shadow-lg z-50 overflow-hidden"
            >
              <div className="p-2 border-b bg-muted/50">
                <p className="text-xs font-semibold text-muted-foreground px-2 py-1">
                  Select Language
                </p>
              </div>
              <div className="max-h-80 overflow-y-auto p-2">
                {locales.map((lang) => (
                  <button
                    key={lang}
                    onClick={() => handleLanguageChange(lang)}
                    className={`w-full flex items-center justify-between px-3 py-2.5 rounded-md transition-colors ${
                      currentLang === lang
                        ? "bg-primary text-primary-foreground"
                        : "hover:bg-muted"
                    } ${isRTL(lang) ? "flex-row-reverse" : ""}`}
                  >
                    <div className={`flex items-center gap-3 ${isRTL(lang) ? "flex-row-reverse" : ""}`}>
                      <span className="font-medium text-sm">
                        {languageNames[lang].native}
                      </span>
                      <span className="text-xs text-muted-foreground">
                        {languageNames[lang].english}
                      </span>
                    </div>
                    {currentLang === lang && (
                      <Check className="h-4 w-4" />
                    )}
                  </button>
                ))}
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}

// Compact version for navbar
export function LanguageSwitcherCompact({ currentLang }: { currentLang: Locale }) {
  const [isOpen, setIsOpen] = useState(false);
  const router = useRouter();
  const pathname = usePathname();

  const handleLanguageChange = (newLang: Locale) => {
    const segments = pathname.split("/").filter(Boolean);
    segments[0] = newLang;
    router.push(`/${segments.join("/")}`);
    setIsOpen(false);
  };

  // Show only selected languages in compact mode
  const compactLanguages: Locale[] = ["th", "en", "zh", "ja", "es"];

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-1 px-3 py-1.5 rounded-md hover:bg-muted transition-colors"
      >
        <Languages className="h-4 w-4" />
        <span className="text-sm font-medium uppercase">{currentLang}</span>
      </button>

      <AnimatePresence>
        {isOpen && (
          <>
            <div
              className="fixed inset-0 z-40"
              onClick={() => setIsOpen(false)}
            />

            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.2 }}
              className="absolute right-0 mt-2 bg-background border rounded-lg shadow-lg z-50 overflow-hidden min-w-[200px]"
            >
              <div className="p-2">
                {compactLanguages.map((lang) => (
                  <button
                    key={lang}
                    onClick={() => handleLanguageChange(lang)}
                    className={`w-full flex items-center justify-between px-3 py-2 rounded-md transition-colors text-sm ${
                      currentLang === lang
                        ? "bg-primary text-primary-foreground"
                        : "hover:bg-muted"
                    }`}
                  >
                    <span>{languageNames[lang].native}</span>
                    {currentLang === lang && <Check className="h-4 w-4" />}
                  </button>
                ))}
                <div className="border-t mt-2 pt-2">
                  <button
                    onClick={() => {
                      setIsOpen(false);
                      // Could open a modal with all languages
                    }}
                    className="w-full px-3 py-2 text-sm text-muted-foreground hover:bg-muted rounded-md transition-colors text-left"
                  >
                    More languages...
                  </button>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}
