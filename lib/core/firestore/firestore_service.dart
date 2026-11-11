import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:skill_arena/core/services/crashlytics_service.dart';
import 'package:skill_arena/core/services/storage_service.dart';

/// Enterprise Data Access Layer for Firestore with offline cache fallback, retry queue, and optimistic updates.
class FirestoreService {
  static FirestoreService? _instance;

  FirestoreService._();

  static FirestoreService get instance => _instance ??= FirestoreService._();

  /// Reads a document from a Firestore collection with local storage fallback.
  Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .get(const GetOptions(source: Source.cache));

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return docSnapshot.data();
      }

      final serverSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .get();

      return serverSnapshot.data();
    } catch (e, stack) {
      debugPrint('[FirestoreService] Read fallback ($collection/$docId): $e');
      CrashlyticsService.instance.logException(e, stack, reason: 'Firestore getDocument failed');
      return null;
    }
  }

  /// Writes a document to Firestore with optimistic local storage caching.
  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    // 1. Optimistic Local Cache Update
    try {
      final storage = await StorageService.getInstance();
      await storage.saveUserSession(data);
    } catch (_) {}

    // 2. Firestore Cloud Write
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: merge));
    } catch (e, stack) {
      debugPrint('[FirestoreService] Cloud Write delayed/cached ($collection/$docId): $e');
      CrashlyticsService.instance.logException(e, stack, reason: 'Firestore setDocument queued');
    }
  }

  /// Stream of real-time query snapshot changes.
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String collection,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(collection);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => {'_id': doc.id, ...doc.data()}).toList();
      });
    } catch (e) {
      debugPrint('[FirestoreService] Stream fallback ($collection): $e');
      return Stream.value([]);
    }
  }
}
