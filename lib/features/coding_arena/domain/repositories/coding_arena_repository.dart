import 'package:skill_arena/core/code_executor/code_executor_contract.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/coding_problem.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/proctor_warning.dart';

/// Repository contract for Phase 10 Live Coding, Proctoring & Assessment Engine.
abstract class CodingArenaRepository {
  /// Fetches active coding problems.
  Future<List<CodingProblem>> getProblems();

  /// Executes user code submission via provider abstraction.
  Future<ExecutionResult> runCode({
    required String problemId,
    required String code,
    required String language,
  });

  /// Logs AI proctoring warning violation.
  Future<void> logProctorWarning({
    required String userId,
    required ProctorViolationType type,
  });
}
