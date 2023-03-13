'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"favicon.png": "b7db0a17fbc12ebd44259cdc5da45349",
"favicon.ico": "a90d93ee0a0876f868b239968a3da3d9",
"assets/NOTICES": "148012adbd9b83b4bc5380e27f8c8657",
"assets/assets/images/office_background.png": "cc0699185338d00e41216fc74c0e05ad",
"assets/assets/images/plant_solo.png": "1afeea7778d2c65b4d52b8b818fb7a12",
"assets/assets/images/cupcake.png": "e21c0276abd8c56f87f2df8e7fdabf82",
"assets/assets/images/person_solo.png": "d2d4d2e652c3efda1d1131a3e7e7113e",
"assets/assets/images/cat.png": "838eccfae7e7a14da9739f177fbb0984",
"assets/assets/images/world/return_door.png": "b89cec8ea0b0f8f30138f498bf4353bb",
"assets/assets/images/icon/boboo_solo.png": "fc53c3f658efd1311a90f2efda1d7061",
"assets/assets/images/cat_solo.png": "44a0762082d432bf614f8b7ae547797f",
"assets/assets/images/dog_solo.png": "0baee419c2c1c5a9c496e97378a32f46",
"assets/assets/images/boboo_solo.png": "fc53c3f658efd1311a90f2efda1d7061",
"assets/assets/images/boboo.png": "7a064f226116229bea2ae158f6ad1c4c",
"assets/assets/images/person.png": "2e82ebe78448fd1b643f43ce6ae03ba5",
"assets/assets/images/plant.png": "404f43cc402de169de85db0c756edf6f",
"assets/assets/images/house_background.png": "f711ee5887d7a896ffa4b6c7b764cb6d",
"assets/assets/images/cupcake_solo.png": "5657b5197389146e832d873489a8de50",
"assets/assets/images/candy_solo.png": "56a0d2d7f2f7b904f7b2d7255da5635b",
"assets/assets/images/door.webp": "c442a7906ae940d319068f1ca7f9f279",
"assets/assets/images/cactus.png": "47c49433df5f0f7d3b920829f9b12beb",
"assets/assets/images/candy.png": "743becfb3d245c6dedaeb974b23aaa49",
"assets/assets/images/dog.png": "62e4dd2427bdefd03736e7044b380a45",
"assets/assets/images/icecream_solo.png": "25153fdc762af1e293951bf92a881cc5",
"assets/assets/images/icecream.png": "2529af50a6f06fd2e02a1f9896e5339c",
"assets/assets/images/cactus_solo.png": "4c46450fa3d479f4709b37c8485c6767",
"assets/assets/images/livingroom_background.png": "7b59b33aa92ab29262cd101b3acac27c",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/AssetManifest.json": "c9b984b8445627bdd5b458c7151c3d66",
"main.dart.js": "943b9e51e5afb094b06bfe6177c4401b",
"manifest.json": "45182840b2f164d51412550433bbd3dd",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"index.html": "6fe166dc311333fb547e71b94307fc33",
"/": "6fe166dc311333fb547e71b94307fc33",
"icons/Icon-192.png": "4f4ce280c6e5f62eb039472ea3214c83",
"icons/apple-icon-precomposed.png": "10fdf4c6d3f208d113bd7b623e20419d",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "021d4ddf7022f8d7f09395c5a9114fc2",
"version.json": "82e6bcccb423458c78459337267775b4"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
