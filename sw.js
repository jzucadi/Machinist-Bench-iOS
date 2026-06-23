// Offline cache for The Machinist's Bench.
// BUMP this version whenever app.html (or any shipped file) changes — the app
// shell is served cache-first, so a stale cache only refreshes when this
// version string changes and the browser reinstalls the worker.
const CACHE = 'machinist-v4.32';

// Same-origin app shell — must cache successfully or install fails.
const CORE = ['./app.html', './manifest.webmanifest', './icon.png'];

// Cross-origin React (the first CDN the loader tries). Precached best-effort so
// the app works fully offline after one online visit, without needing a reload.
// Opaque responses can't go through addAll, so they're fetched + put by hand.
const CDN = [
  'https://unpkg.com/react@18.3.1/umd/react.production.min.js',
  'https://unpkg.com/react-dom@18.3.1/umd/react-dom.production.min.js'
];

// Google Fonts stylesheet (must match the @import in app.html byte-for-byte).
// The CSS only names the woff2 files — they're parsed out and cached too.
const FONTS_CSS = 'https://fonts.googleapis.com/css2?family=Chakra+Petch:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400;500;700&display=swap';

async function putBestEffort(c, url, opts) {
  try { await c.put(url, await fetch(url, opts)); } catch (_) { /* offline/CDN down — runtime cache catches it later */ }
}

async function precacheFonts(c) {
  try {
    const res = await fetch(FONTS_CSS); // googleapis sends CORS, so the body is readable
    await c.put(FONTS_CSS, res.clone());
    const css = await res.text();
    const urls = [...css.matchAll(/url\((https:\/\/[^)]+)\)/g)].map((m) => m[1]);
    await Promise.all(urls.map((u) => putBestEffort(c, u, { mode: 'no-cors' })));
  } catch (_) { /* fonts are cosmetic — system fallback if this fails */ }
}

self.addEventListener('install', (e) => {
  e.waitUntil((async () => {
    const c = await caches.open(CACHE);
    await c.addAll(CORE);
    await Promise.all([
      ...CDN.map((url) => putBestEffort(c, url, { mode: 'no-cors' })),
      precacheFonts(c)
    ]);
    self.skipWaiting();
  })());
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// Cache-first, fall back to network and cache what comes back — including
// opaque cross-origin responses (CDN, fonts) so the next load is offline.
self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET') return;
  e.respondWith(
    caches.match(req).then((hit) => {
      if (hit) return hit;
      return fetch(req).then((res) => {
        if (res && (res.ok || res.type === 'opaque')) {
          const copy = res.clone();
          caches.open(CACHE).then((c) => c.put(req, copy));
        }
        return res;
      }).catch(() => (req.mode === 'navigate' ? caches.match('./app.html') : undefined));
    })
  );
});
