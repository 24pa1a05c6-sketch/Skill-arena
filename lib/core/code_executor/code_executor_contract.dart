enum ExecutionStatus { success, compileError, runtimeError, timeLimitExceeded, wrongAnswer }

class ExecutionResult {
  final ExecutionStatus status;
  final String stdout;
  final String stderr;
  final int runtimeMs;
  final int memoryKb;
  final int passedTestCases;
  final int totalTestCases;

  const ExecutionResult({
    required this.status,
    this.stdout = '',
    this.stderr = '',
    this.runtimeMs = 45,
    this.memoryKb = 1024,
    required this.passedTestCases,
    required this.totalTestCases,
  });
}

abstract class CodeExecutorContract {
  Future<ExecutionResult> executeCode({
    required String problemId,
    required String code,
    required String language,
  });
}

class MockCodeExecutor implements CodeExecutorContract {
  @override
  Future<ExecutionResult> executeCode({
    required String problemId,
    required String code,
    required String language,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    if (code.contains('error')) {
      return const ExecutionResult(
        status: ExecutionStatus.compileError,
        stderr: 'SyntaxError: Unexpected token or compilation failure',
        passedTestCases: 0,
        totalTestCases: 5,
      );
    }

    return const ExecutionResult(
      status: ExecutionStatus.success,
      stdout: 'All 5 Test Cases Passed! [Output: Verified]',
      runtimeMs: 38,
      memoryKb: 512,
      passedTestCases: 5,
      totalTestCases: 5,
    );
  }
}
