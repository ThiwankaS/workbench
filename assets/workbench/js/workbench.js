/**
 * Thiwanka's Workbench — Client script
 * -----------------------------------------------------------------------------
 * Lightweight enhancements for the static Neovim reference page:
 *   - Highlight the sticky nav link for the section in view
 *   - Show a back-to-top control after scrolling
 *   - Sync external links (noopener) and footer year
 *
 * No dependencies. Safe for file:// and local http opens.
 *
 * @author ThiwankaS
 * @see    workbench.html
 */

(function workbenchInit() {
  "use strict";

  /** Nav anchor href → section id (without #). */
  const NAV_SELECTOR = 'nav[aria-label="Sections"] a[href^="#"]';
  const SECTION_SELECTOR = "main.grid section.card[id]";
  const ACTIVE_CLASS = "is-active";
  const BACK_TO_TOP_ID = "back-to-top";
  const SCROLL_SHOW_PX = 400;

  /**
   * @param {string} selector
   * @returns {HTMLElement|null}
   */
  function $(selector) {
    return document.querySelector(selector);
  }

  /**
   * @param {string} selector
   * @returns {HTMLElement[]}
   */
  function $$(selector) {
    return Array.from(document.querySelectorAll(selector));
  }

  /**
   * Map nav links to their target section elements.
   * @returns {{ link: HTMLAnchorElement, section: HTMLElement, id: string }[]}
   */
  function buildNavSectionPairs() {
    return $$(NAV_SELECTOR)
      .map(function mapLink(link) {
        const id = link.getAttribute("href").slice(1);
        const section = document.getElementById(id);
        if (!section) {
          return null;
        }
        return { link: link, section: section, id: id };
      })
      .filter(Boolean);
  }

  /**
   * Mark the nav link that matches `activeId`; clear others.
   * @param {{ link: HTMLAnchorElement, id: string }[]} pairs
   * @param {string} activeId
   */
  function setActiveNav(pairs, activeId) {
    pairs.forEach(function eachPair(pair) {
      const isActive = pair.id === activeId;
      pair.link.classList.toggle(ACTIVE_CLASS, isActive);
      if (isActive) {
        pair.link.setAttribute("aria-current", "true");
      } else {
        pair.link.removeAttribute("aria-current");
      }
    });
  }

  /**
   * Pick the section whose top is closest above the viewport midpoint.
   * @param {{ section: HTMLElement, id: string }[]} pairs
   * @returns {string}
   */
  function findActiveSectionId(pairs) {
    const marker = window.scrollY + window.innerHeight * 0.35;
    let current = pairs[0] ? pairs[0].id : "";

    pairs.forEach(function eachPair(pair) {
      const top = pair.section.offsetTop;
      if (top <= marker) {
        current = pair.id;
      }
    });

    return current;
  }

  /**
   * Sticky nav: update active link while scrolling.
   * @param {{ link: HTMLAnchorElement, section: HTMLElement, id: string }[]} pairs
   */
  function initSectionNav(pairs) {
    if (pairs.length === 0) {
      return;
    }

    let ticking = false;

    function onScroll() {
      if (ticking) {
        return;
      }
      ticking = true;
      window.requestAnimationFrame(function update() {
        setActiveNav(pairs, findActiveSectionId(pairs));
        ticking = false;
      });
    }

    window.addEventListener("scroll", onScroll, { passive: true });
    onScroll();
  }

  /**
   * Floating control to return to the page top.
   */
  function initBackToTop() {
    const button = document.createElement("button");
    button.type = "button";
    button.id = BACK_TO_TOP_ID;
    button.className = "back-to-top";
    button.setAttribute("aria-label", "Back to top");
    button.title = "Back to top";
    button.textContent = "↑";
    document.body.appendChild(button);

    function toggleVisible() {
      const show = window.scrollY > SCROLL_SHOW_PX;
      button.classList.toggle("is-visible", show);
    }

    button.addEventListener("click", function onClick() {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });

    window.addEventListener("scroll", toggleVisible, { passive: true });
    toggleVisible();
  }

  /**
   * Harden external links opened from the footprint/footer.
   */
  function initExternalLinks() {
    $$('a[target="_blank"]').forEach(function eachLink(link) {
      if (!link.getAttribute("rel")) {
        link.setAttribute("rel", "noopener noreferrer");
      }
    });
  }

  /**
   * Optional: stamp footer year if an element carries data-year.
   */
  function initFooterYear() {
    const el = $("[data-year]");
    if (el) {
      el.textContent = String(new Date().getFullYear());
    }
  }

  /* --- Bootstrap when DOM is ready --- */

  function onReady() {
    const pairs = buildNavSectionPairs();
    initSectionNav(pairs);
    initBackToTop();
    initExternalLinks();
    initFooterYear();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", onReady);
  } else {
    onReady();
  }
})();
