# Add i18n (Internationalization) Support

## Summary

Add proper i18n support so the product can be switched between multiple languages (e.g. Chinese/English UI), and make it
easy to add more locales in the future.

## Background / Current State

- Frontend currently has a Chinese-first UI (labels, toasts, validation messages, etc.) hardcoded in components and
  pages.
- There is no centralized translation dictionary or locale switch.
- Admin pages (dashboard, knowledge base, traces, settings) and chat UI all mix Chinese text inside React components.

## Scope / Requirements

- Introduce a standard i18n solution on the frontend (e.g., `react-i18next` or `@formatjs/react-intl`).
- Extract user-facing strings into translation files, at least for
    - Chat UI (ChatPage, messages, feedback, errors)
    - Auth (LoginPage, auth toasts)
    - Admin sections (Dashboard, Knowledge, Ingestion, Traces, Settings)
    - Common UI (buttons, menus, empty states, loading text)
- Provide at least two locales:
    - `zh-CN` (current behavior, default)
    - `en` (English)
- Add a language switch control (e.g., in header/sidebar or settings) that:
    - Persists user choice in localStorage
    - Applies immediately without full reload if possible
- Ensure text from backend error responses can be shown in a localized/friendly way where appropriate (e.g., mapping
  known error codes to localized messages).