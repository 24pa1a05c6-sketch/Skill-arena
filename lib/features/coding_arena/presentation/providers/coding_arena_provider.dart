import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/code_executor/code_executor_contract.dart';
import 'package:skill_arena/features/coding_arena/data/datasources/firestore_coding_arena_datasource.dart';
import 'package:skill_arena/features/coding_arena/data/repositories/coding_arena_repository_impl.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/coding_problem.dart';
import 'package:skill_arena/features/coding_arena/domain/entities/proctor_warning.dart';
import 'package:skill_arena/features/coding_arena/domain/repositories/coding_arena_repository.dart';

class CodingArenaState {
  final List<CodingProblem> problems;
  final int currentProblemIndex;
  final String currentCode;
  final String selectedLanguage;
  final ExecutionResult? latestResult;
  final int proctorViolationsCount;
  final bool isExecuting;
  final bool isLoading;

  const CodingArenaState({
    this.problems = const [],
    this.currentProblemIndex = 0,
    this.currentCode = '''void main() {
  print("Initializing Riverpod Concurrency Lock...");
}''',
    this.selectedLanguage = 'dart',
    this.latestResult,
    this.proctorViolationsCount = 0,
    this.isExecuting = false,
    this.isLoading = false,
  });

  CodingArenaState copyWith({
    List<CodingProblem>? problems,
    int? currentProblemIndex,
    String? currentCode,
    String? selectedLanguage,
    ExecutionResult? latestResult,
    int? proctorViolationsCount,
    bool? isExecuting,
    bool? isLoading,
  }) {
    return CodingArenaState(
      problems: problems ?? this.problems,
      currentProblemIndex: currentProblemIndex ?? this.currentProblemIndex,
      currentCode: currentCode ?? this.currentCode,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      latestResult: latestResult ?? this.latestResult,
      proctorViolationsCount: proctorViolationsCount ?? this.proctorViolationsCount,
      isExecuting: isExecuting ?? this.isExecuting,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final firestoreCodingArenaDatasourceProvider = Provider<FirestoreCodingArenaDatasource>((ref) {
  return FirestoreCodingArenaDatasource();
});

final codingArenaRepositoryProvider = Provider<CodingArenaRepository>((ref) {
  final ds = ref.watch(firestoreCodingArenaDatasourceProvider);
  return CodingArenaRepositoryImpl(ds);
});

final codingArenaProvider = StateNotifierProvider<CodingArenaNotifier, CodingArenaState>((ref) {
  final repo = ref.watch(codingArenaRepositoryProvider);
  return CodingArenaNotifier(repo);
});

class CodingArenaNotifier extends StateNotifier<CodingArenaState> {
  final CodingArenaRepository _repository;

  CodingArenaNotifier(this._repository) : super(const CodingArenaState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final problems = await _repository.getProblems();
    state = state.copyWith(problems: problems, isLoading: false);
  }

  void updateCode(String code) {
    state = state.copyWith(currentCode: code);
  }

  Future<void> executeCode() async {
    if (state.problems.isEmpty) return;

    state = state.copyWith(isExecuting: true);
    final currentProblem = state.problems[state.currentProblemIndex];

    final result = await _repository.runCode(
      problemId: currentProblem.id,
      code: state.currentCode,
      language: state.selectedLanguage,
    );

    state = state.copyWith(latestResult: result, isExecuting: false);
  }

  Future<void> triggerProctorViolation(ProctorViolationType type) async {
    final count = state.proctorViolationsCount + 1;
    await _repository.logProctorWarning(userId: 'vanguard_2030', type: type);
    state = state.copyWith(proctorViolationsCount: count);
  }
}
