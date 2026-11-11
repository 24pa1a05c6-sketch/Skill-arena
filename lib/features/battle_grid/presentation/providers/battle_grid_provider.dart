import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/battle_grid/data/datasources/firestore_battle_grid_datasource.dart';
import 'package:skill_arena/features/battle_grid/data/repositories/battle_grid_repository_impl.dart';
import 'package:skill_arena/features/battle_grid/domain/entities/tournament.dart';
import 'package:skill_arena/features/battle_grid/domain/repositories/battle_grid_repository.dart';

class BattleGridState {
  final List<Tournament> tournaments;
  final List<Map<String, dynamic>> leaderboard;
  final String searchQuery;
  final String selectedFilter;
  final bool isLoading;
  final Set<String> joinedTournamentIds;

  const BattleGridState({
    this.tournaments = const [],
    this.leaderboard = const [],
    this.searchQuery = '',
    this.selectedFilter = 'ALL',
    this.isLoading = false,
    this.joinedTournamentIds = const {},
  });

  BattleGridState copyWith({
    List<Tournament>? tournaments,
    List<Map<String, dynamic>>? leaderboard,
    String? searchQuery,
    String? selectedFilter,
    bool? isLoading,
    Set<String>? joinedTournamentIds,
  }) {
    return BattleGridState(
      tournaments: tournaments ?? this.tournaments,
      leaderboard: leaderboard ?? this.leaderboard,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      joinedTournamentIds: joinedTournamentIds ?? this.joinedTournamentIds,
    );
  }
}

final firestoreBattleGridDataSourceProvider = Provider<FirestoreBattleGridDatasource>((ref) {
  return FirestoreBattleGridDatasource();
});

final battleGridRepositoryProvider = Provider<BattleGridRepository>((ref) {
  final datasource = ref.watch(firestoreBattleGridDataSourceProvider);
  return BattleGridRepositoryImpl(datasource);
});

final battleGridProvider =
    StateNotifierProvider<BattleGridNotifier, BattleGridState>((ref) {
  final repository = ref.watch(battleGridRepositoryProvider);
  final datasource = ref.watch(firestoreBattleGridDataSourceProvider);
  return BattleGridNotifier(repository, datasource);
});

class BattleGridNotifier extends StateNotifier<BattleGridState> {
  final BattleGridRepository _repository;
  final FirestoreBattleGridDatasource _dataSource;

  BattleGridNotifier(this._repository, this._dataSource)
      : super(const BattleGridState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final tournaments = await _repository.getTournaments();
      final leaderboard = await _repository.getLeaderboard();
      final joinedIds = await _dataSource.getJoinedTournaments();
      state = state.copyWith(
        tournaments: tournaments,
        leaderboard: leaderboard,
        joinedTournamentIds: joinedIds,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  Future<void> joinTournament(String id) async {
    await _repository.joinTournament(id);
    final updated = Set<String>.from(state.joinedTournamentIds)..add(id);
    state = state.copyWith(joinedTournamentIds: updated);
  }

  List<Tournament> get filteredTournaments {
    return state.tournaments.where((t) {
      final matchesSearch = state.searchQuery.isEmpty ||
          t.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(state.searchQuery.toLowerCase());

      final matchesFilter = state.selectedFilter == 'ALL' ||
          (state.selectedFilter == 'LIVE' && t.status == 'live') ||
          (state.selectedFilter == 'UPCOMING' && t.status == 'upcoming');

      return matchesSearch && matchesFilter;
    }).toList();
  }
}
