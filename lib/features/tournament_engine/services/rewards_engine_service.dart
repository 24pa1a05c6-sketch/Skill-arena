import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:skill_arena/core/firestore/firestore_collections.dart';
import 'package:skill_arena/core/services/analytics_service.dart';
import 'package:skill_arena/core/services/storage_service.dart';

/// Enterprise Rewards Distribution Engine for XP, $ARENA Tokens, Badges & Certificates.
class RewardsEngineService {
  static RewardsEngineService? _instance;

  RewardsEngineService._();

  static RewardsEngineService get instance => _instance ??= RewardsEngineService._();

  /// Distributes rewards to tournament champions and top placements.
  Future<void> distributeTournamentRewards({
    required String tournamentId,
    required String winnerId,
    required String winnerName,
    required int prizePool,
    required int xpBonus,
  }) async {
    // 1. StorageService Offline Cache Update
    final storage = await StorageService.getInstance();
    await storage.addXpEarnedToday(xpBonus);

    // 2. Cloud Firestore Sync
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.rewards)
          .add({
        'tournamentId': tournamentId,
        'userId': winnerId,
        'prizeTokens': prizePool,
        'xpBonus': xpBonus,
        'badgeName': 'Tournament Champion',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(winnerId)
          .set({
        'arenaTokens': FieldValue.increment(prizePool),
        'xp': FieldValue.increment(xpBonus),
        'badges': FieldValue.arrayUnion(['Tournament Champion']),
      }, SetOptions(merge: true));

      AnalyticsService.instance.logTournamentWon(tournamentId, prizePool);
      AnalyticsService.instance.logBadgeUnlocked('Tournament Champion');
      debugPrint('[RewardsEngine] Successfully distributed $prizePool tokens & $xpBonus XP to $winnerName');
    } catch (e) {
      debugPrint('[RewardsEngine] Firestore sync cached offline: $e');
    }
  }
}
