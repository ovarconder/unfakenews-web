"use client";

import Link from "next/link";
import { Menu, Search } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Locale } from "@/lib/i18n";
import { LanguageSwitcherCompact } from "@/components/language-switcher";

interface NavbarProps {
  translations: any;
  locale: Locale;
}

export function Navbar({ translations, locale }: NavbarProps) {
  const today = new Date().toLocaleDateString(locale, {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return (
    <nav className="border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 sticky top-0 z-50 shadow-sm">
      {/* Top bar */}
      <div className="border-b py-2 bg-muted/30">
        <div className="container mx-auto px-4 flex items-center justify-between text-sm text-muted-foreground">
          <div className="flex items-center gap-4">
            <time>{today}</time>
          </div>
          <div className="flex items-center gap-4">
            <LanguageSwitcherCompact currentLang={locale} />
            <Link href={`/${locale}/auth/signin`}>
              <Button variant="ghost" size="sm">
                {translations.auth.signIn}
              </Button>
            </Link>
          </div>
        </div>
      </div>

      {/* Main navbar */}
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center gap-8">
            <Button variant="ghost" size="icon" className="lg:hidden">
              <Menu className="h-5 w-5" />
            </Button>
            <Link href={`/${locale}`} className="text-2xl font-bold tracking-tight font-serif">
              UnfakeNews
            </Link>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden lg:flex items-center gap-8">
            <Link
              href={`/${locale}`}
              className="text-sm font-medium hover:text-primary transition-colors"
            >
              {translations.nav.home}
            </Link>
            <Link
              href={`/${locale}/category/politics`}
              className="text-sm font-medium hover:text-primary transition-colors"
            >
              {translations.nav.politics}
            </Link>
            <Link
              href={`/${locale}/category/business`}
              className="text-sm font-medium hover:text-primary transition-colors"
            >
              {translations.nav.business}
            </Link>
            <Link
              href={`/${locale}/category/technology`}
              className="text-sm font-medium hover:text-primary transition-colors"
            >
              {translations.nav.technology}
            </Link>
            <Link
              href={`/${locale}/category/culture`}
              className="text-sm font-medium hover:text-primary transition-colors"
            >
              {translations.nav.culture}
            </Link>
            <Link
              href={`/${locale}/category/sports`}
              className="text-sm font-medium hover:text-primary transition-colors"
            >
              {translations.nav.sports}
            </Link>
          </div>

          <Button variant="ghost" size="icon">
            <Search className="h-5 w-5" />
          </Button>
        </div>
      </div>
    </nav>
  );
}
