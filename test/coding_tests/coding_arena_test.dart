import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_arena/core/code_executor/code_executor_contract.dart';
import 'package:skill_arena/core/code_executor/judge0_code_executor.dart';
import 'package:skill_arena/features/coding_arena/data/datasources/firestore_coding_arena_datasource.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/coding_problem.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/proctor_warning.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 10 Live Coding, Proctoring & Assessment Unit Tests', () {
    test('CodingProblem serialization and limit parameters', () {
      const prob = CodingProblem(
        id: 'prob_test',
        title: 'Isolate Mutex Lock',
        description: 'Test Problem',
        difficulty: 'Expert',
        timeLimitMs: 2000,
        memoryLimitMb: 512,
      );

      final map = prob.toMap();
      final restored = CodingProblem.fromMap(map);

      expect(restored.id, equals('prob_test'));
      expect(restored.difficulty, equals('Expert'));
      expect(restored.timeLimitMs, equals(2000));
    });

    test('Judge0CodeExecutor runs valid code solution', () async {
      final executor = Judge0CodeExecutor();
      final result = await executor.executeCode(
        problemId: 'prob_1',
        code: 'void main() { print("Passed"); }',
        language: 'dart',
      );

      expect(result.status, equals(ExecutionStatus.success));
      expect(result.passedTestCases, equals(5));
      expect(result.totalTestCases, equals(5));
    });

    test('ProctorWarning serialization and violation types', () {
      final warning = ProctorWarning(
        id: 'proc_1',
        userId: 'usr_test',
        violationType: ProctorViolationType.tabSwitch,
        timestamp: DateTime.now(),
      );

      final map = warning.toMap();
      final restored = ProctorWarning.fromMap(map);

      expect(restored.violationType, equals(ProctorViolationType.tabSwitch));
    });

    test('FirestoreCodingArenaDatasource problem catalog & code execution', () async {
      final ds = FirestoreCodingArenaDatasource();
      final problems = await ds.getProblems();

      expect(problems.length, greaterThanOrEqualTo(2));
      expect(problems.first.title, contains('Riverpod'));

      final execution = await ds.runCode(
        problemId: problems.first.id,
        code: 'void main() {}',
        language: 'dart',
      );

      expect(execution.status, equals(ExecutionStatus.success));
    });
  });
}
