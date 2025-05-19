// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:injectable/injectable.dart';
// import 'package:path_provider/path_provider.dart';
//
// /// A custom cache manager for optimizing image caching
// @singleton
// class AppImageCacheManager {
//   static const String _key = 'appImageCache';
//   static const Duration _stalePeriod = Duration(days: 7);
//   static const int _maxCacheSize = 200; // Maximum number of cached files
//
//   late final CacheManager _instance;
//   bool _initialized = false;
//
//   /// Initialize the cache manager
//   @PostConstruct()
//   Future<void> init() async {
//     if (_initialized) return;
//
//     final cacheDir = await _getCacheDirectory();
//
//     _instance = CacheManager(
//       Config(
//         _key,
//         stalePeriod: _stalePeriod,
//         maxNrOfCacheObjects: _maxCacheSize,
//         repo: JsonCacheInfoRepository(databaseName: _key),
//         fileService: HttpFileService(),
//         cacheDir: cacheDir,
//       ),
//     );
//
//     _initialized = true;
//   }
//
//   /// Get the cache directory
//   Future<String> _getCacheDirectory() async {
//     final directory = await getTemporaryDirectory();
//     final cacheDir = '${directory.path}/image_cache';
//
//     // Create the directory if it doesn't exist
//     final dir = Directory(cacheDir);
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//
//     return cacheDir;
//   }
//
//   /// Get the cache manager instance
//   CacheManager get instance {
//     assert(_initialized, 'AppImageCacheManager must be initialized before use');
//     return _instance;
//   }
//
//   /// Get a file from the cache
//   Future<File> getSingleFile(String url) {
//     return instance.getSingleFile(url);
//   }
//
//   /// Get a file from the cache with custom options
//   Stream<FileResponse> getFileStream(
//     String url, {
//     Map<String, String>? headers,
//     bool withProgress = false,
//   }) {
//     return instance.getFileStream(
//       url,
//       headers: headers,
//       withProgress: withProgress,
//     );
//   }
//
//   /// Remove a file from the cache
//   Future<void> removeFile(String url) {
//     return instance.removeFile(url);
//   }
//
//   /// Clear the entire cache
//   Future<void> clearCache() {
//     return instance.emptyCache();
//   }
//
//   /// Get the cache size in bytes
//   Future<int> getCacheSize() async {
//     final directory = Directory(await _getCacheDirectory());
//     int totalSize = 0;
//
//     try {
//       if (await directory.exists()) {
//         await for (final file in directory.list(recursive: true, followLinks: false)) {
//           if (file is File) {
//             totalSize += await file.length();
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('Error calculating cache size: $e');
//     }
//
//     return totalSize;
//   }
//
//   /// Get the cache size as a formatted string
//   Future<String> getFormattedCacheSize() async {
//     final bytes = await getCacheSize();
//
//     if (bytes < 1024) {
//       return '$bytes B';
//     } else if (bytes < 1024 * 1024) {
//       return '${(bytes / 1024).toStringAsFixed(2)} KB';
//     } else if (bytes < 1024 * 1024 * 1024) {
//       return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
//     } else {
//       return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
//     }
//   }
//
//   /// Dispose the cache manager
//   @disposeMethod
//   void dispose() {
//     // Nothing to dispose
//   }
// }
