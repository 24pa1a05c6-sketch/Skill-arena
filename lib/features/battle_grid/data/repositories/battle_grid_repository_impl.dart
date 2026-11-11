import 'package:skill_arena/features/battle_grid/data/datasources/firestore_battle_grid_datasource.dart';
import 'package:skill_arena/features/battle_grid/domain/entities/tournament.dart';
import 'package:skill_arena/features/battle_grid/domain/repositories/battle_grid_repository.dart';

/// Implementation of [BattleGridRepository] using Firestore.
class BattleGridRepositoryImpl implements BattleGridRepository {
  final FirestoreBattleGridDatasource _dataSource;

  BattleGridRepositoryImpl(this._dataSource);

  @override
  Future<List<Tournament>> getTournaments() {
    return _dataSource.getTournaments();
  }

  @override
  Future<Tournament> getTournamentDetails(String id) {
    return _dataSource.getTournamentDetails(id);
  }

  @override
  Future<void> joinTournament(String id) {
    return _dataSource.joinTournament(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getLeaderboard() {
    return _dataSource.getLeaderboard();
  }
}
