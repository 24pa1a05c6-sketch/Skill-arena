import 'package:skill_arena/core/services/storage_service.dart';
import 'package:skill_arena/features/battle_grid/domain/entities/tournament.dart';

/// Production-ready data source for Battle Grid with StorageService persistence.
class BattleGridDataSource {
  final List<Tournament> _mockTournaments = [
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

  final List<Map<String, dynamic>> _mockLeaderboard = [
    {'id': 'u1', 'name': '0xNinja', 'rank': 1, 'earnings': 150000, 'avatarUrl': ''},
    {'id': 'u2', 'name': 'CodeMaster', 'rank': 2, 'earnings': 120000, 'avatarUrl': ''},
    {'id': 'u3', 'name': 'DartVader', 'rank': 3, 'earnings': 95000, 'avatarUrl': ''},
    {'id': 'u4', 'name': 'BugSquasher', 'rank': 4, 'earnings': 80000, 'avatarUrl': ''},
    {'id': 'u5', 'name': 'AI_Whisperer', 'rank': 5, 'earnings': 75000, 'avatarUrl': ''},
  ];

  Future<List<Tournament>> getTournaments() async {
    return _mockTournaments;
  }

  Future<Tournament> getTournamentDetails(String id) async {
    return _mockTournaments.firstWhere((t) => t.id == id);
  }

  Future<void> joinTournament(String id) async {
    final storage = await StorageService.getInstance();
    await storage.saveJoinedTournament(id);
  }

  Future<Set<String>> getJoinedTournaments() async {
    final storage = await StorageService.getInstance();
    return storage.getJoinedTournaments().toSet();
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    return _mockLeaderboard;
  }
}
