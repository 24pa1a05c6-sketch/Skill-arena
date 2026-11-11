import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Centralized Enterprise Cloud Storage Service for profile images, certificates, course thumbnails & assets.
class CloudStorageService {
  static CloudStorageService? _instance;
  FirebaseStorage? _storage;

  CloudStorageService._();

  static CloudStorageService get instance => _instance ??= CloudStorageService._();

  void initialize() {
    try {
      _storage = FirebaseStorage.instance;
    } catch (e) {
      debugPrint('[CloudStorageService] Init fallback: $e');
    }
  }

  /// Uploads a file to Firebase Cloud Storage and returns the public download URL.
  Future<String?> uploadFile({
    required String path,
    required File file,
    Function(double progress)? onProgress,
  }) async {
    try {
      final ref = _storage?.ref().child(path);
      final uploadTask = ref?.putFile(file);

      if (onProgress != null && uploadTask != null) {
        uploadTask.snapshotEvents.listen((event) {
          final progress = event.bytesTransferred / event.totalBytes;
          onProgress(progress);
        });
      }

      final snapshot = await uploadTask;
      return await snapshot?.ref.getDownloadURL();
    } catch (e) {
      debugPrint('[CloudStorageService] Upload failed: $e');
      return null;
    }
  }

  /// Uploads raw bytes (e.g., certificate PDF or image buffer) and returns download URL.
  Future<String?> uploadData({
    required String path,
    required Uint8List data,
    required String mimeType,
  }) async {
    try {
      final ref = _storage?.ref().child(path);
      final uploadTask = ref?.putData(data, SettableMetadata(contentType: mimeType));
      final snapshot = await uploadTask;
      return await snapshot?.ref.getDownloadURL();
    } catch (e) {
      debugPrint('[CloudStorageService] Upload data failed: $e');
      return null;
    }
  }

  /// Deletes a file from Firebase Storage.
  Future<void> deleteFile(String path) async {
    try {
      await _storage?.ref().child(path).delete();
    } catch (_) {}
  }
}
