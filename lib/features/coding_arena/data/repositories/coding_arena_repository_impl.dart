import 'package:skill_arena/core/code_executor/code_executor_contract.dart';
import 'package:skill_arena/features/coding_arena/data/datasources/firestore_coding_arena_datasource.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/coding_problem.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/proctor_warning.dart';
import 'package:skill_arena/features/coding_arena/domain/repositories/coding_arena_repository.dart';

/// Implementation of [CodingArenaRepository].
class CodingArenaRepositoryImpl implements CodingArenaRepository {
  final FirestoreCodingArenaDatasource _datasource;

  CodingArenaRepositoryImpl(this._datasource);

  @override
  Future<List<CodingProblem>> getProblems() {
    return _datasource.getProblems();
  }

  @override
  Future<ExecutionResult> runCode({
    required String problemId,
    required String code,
    required String language,
  }) {
    return _datasource.runCode(problemId: problemId, code: code, language: language);
  }

  @override
  Future<void> logProctorWarning({
    required String userId,
    required ProctorViolationType type,
  }) {
    return _datasource.logProctorWarning(userId: userId, type: type);
  }
}
