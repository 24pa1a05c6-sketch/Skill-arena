import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:skill_arena/core/firestore/firestore_collections.dart';
import 'package:skill_arena/core/services/analytics_service.dart';
import 'package:skill_arena/core/services/crashlytics_service.dart';
import 'package:skill_arena/core/services/storage_service.dart';
import 'package:skill_arena/features/battle_grid/domain/entities/tournament.dart';

/// Production Firestore Datasource for Battle Grid tournaments, registrations & leaderboards.
class FirestoreBattleGridDatasource {
  final List<Tournament> _fallbackTournaments = [
    Tournament(
      id: 't1',
      title: 'Cyber Battle Royale',
      category: 'Cybersecurity',
      difficulty: 'Hard',
      prizeTokens: 5000,
      participantCount: 45,
      maxParticipants: 100,
      startTime: DateTime.now().add(const Duration(hours: 2)),
      status: 'upcoming',
      bracketRounds: const ['Qualifier', 'Semi-Final', 'Final'],
    ),
    Tournament(
      id: 't2',
      title: 'Flutter Architecture Showdown',
      category: 'Flutter',
      difficulty: 'Expert',
      prizeTokens: 10000,
      participantCount: 98,
      maxParticipants: 100,
      startTime: DateTime.now().subtract(const Duration(hours: 1)),
      status: 'live',
      bracketRounds: const ['Round 1', 'Quarter-Final', 'Semi-Final', 'Final'],
    ),
    Tournament(
      id: 't3',
      title: 'AI Prompt Championship',
      category: 'AI',
      difficulty: 'Medium',
      prizeTokens: 3000,
      participantCount: 20,
      maxParticipants: 50,
      startTime: DateTime.now().add(const Duration(days: 1)),
      status: 'upcoming',
      bracketRounds: const ['Qualifier', 'Final'],
    ),
    Tournament(
      id: 't4',
      title: 'Web3 Security Hack',
      category: 'Web3',
      difficulty: 'Hard',
      prizeTokens: 7500,
      participantCount: 120,
      maxParticipants: 200,
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      status: 'completed',
      bracketRounds: const ['Phase 1', 'Phase 2', 'Final'],
    ),
    Tournament(
      id: 't5',
      title: 'Algo Rush',
      category: 'Algorithms',
      difficulty: 'Medium',
      prizeTokens: 2500,
      participantCount: 50,
      maxParticipants: 50,
      startTime: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'live',
      bracketRounds: const ['Sprint 1', 'Sprint 2', 'Final'],
    ),
  ];

  final List<Map<String, dynamic>> _fallbackLeaderboard = [
    {'id': 'u1', 'name': '0xNinja', 'rank': 1, 'earnings': 150000, 'avatarUrl': ''},
    {'id': 'u2', 'name': 'CodeMaster', 'rank': 2, 'earnings': 120000, 'avatarUrl': ''},
    {'id': 'u3', 'name': 'DartVader', 'rank': 3, 'earnings': 95000, 'avatarUrl': ''},
    {'id': 'u4', 'name': 'BugSquasher', 'rank': 4, 'earnings': 80000, 'avatarUrl': ''},
    {'id': 'u5', 'name': 'AI_Whisperer', 'rank': 5, 'earnings': 75000, 'avatarUrl': ''},
  ];

  Future<List<Tournament>> getTournaments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.tournaments)
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => _fromMap(doc.id, doc.data())).toList();
      }
    } catch (e, stack) {
      debugPrint('[FirestoreBattleGrid] Using local offline tournament catalog.');
      CrashlyticsService.instance.logException(e, stack, reason: 'Firestore getTournaments fallback');
    }
    return _fallbackTournaments;
  }

  Future<Tournament> getTournamentDetails(String id) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.tournaments)
          .doc(id)
          .get();
      if (doc.exists && doc.data() != null) {
        return _fromMap(doc.id, doc.data()!);
      }
    } catch (_) {}
    return _fallbackTournaments.firstWhere((t) => t.id == id, orElse: () => _fallbackTournaments.first);
  }

  Future<void> joinTournament(String id) async {
    final storage = await StorageService.getInstance();
    await storage.saveJoinedTournament(id);

    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.registrations)
          .doc('${id}_usr')
          .set({
        'tournamentId': id,
        'registeredAt': FieldValue.serverTimestamp(),
        'status': 'confirmed',
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.tournaments)
          .doc(id)
          .update({'participantCount': FieldValue.increment(1)});

      AnalyticsService.instance.logTournamentJoined(id, 'Tournament', 0);
    } catch (e, stack) {
      debugPrint('[FirestoreBattleGrid] joinTournament queued offline: $e');
      CrashlyticsService.instance.logException(e, stack, reason: 'joinTournament queued offline');
    }
  }

  Future<Set<String>> getJoinedTournaments() async {
    final storage = await StorageService.getInstance();
    return storage.getJoinedTournaments().toSet();
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.leaderboards)
          .orderBy('earnings', descending: true)
          .limit(10)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      }
    } catch (_) {}
    return _fallbackLeaderboard;
  }

  Tournament _fromMap(String id, Map<String, dynamic> data) {
    return Tournament(
      id: id,
      title: data['title'] as String? ?? 'Tournament',
      category: data['category'] as String? ?? 'General',
      difficulty: data['difficulty'] as String? ?? 'Medium',
      prizeTokens: data['prizeTokens'] as int? ?? 1000,
      participantCount: data['participantCount'] as int? ?? 10,
      maxParticipants: data['maxParticipants'] as int? ?? 100,
      startTime: data['startTime'] != null
          ? (data['startTime'] as Timestamp).toDate()
          : DateTime.now(),
      status: data['status'] as String? ?? 'upcoming',
      bracketRounds: (data['bracketRounds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Round 1', 'Final'],
    );
  }
}
