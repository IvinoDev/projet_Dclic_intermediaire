// Service Worker for sqflite_common_ffi_web
importScripts('sqlite3.wasm.js');

self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'INIT_SQLITE') {
    // Initialize SQLite
    console.log('SQLite Service Worker initialized');
  }
});