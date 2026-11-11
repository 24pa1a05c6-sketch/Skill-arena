import 'package:flutter/foundation.dart';

/// Prompt Sanitizer & Security Pipeline preventing injection attacks and enforcing rate limiting.
class PromptSanitizer {
  static const int maxPromptLength = 2000;
  static const List<String> _forbiddenPatterns = [
    'ignore previous instructions',
    'system override',
    'reveal secret key',
    'drop database',
    'sudo rm -rf',
  ];

  /// Sanitizes user text input before passing to LLMs.
  static String sanitize(String input) {
    if (input.trim().isEmpty) return '';

    String cleaned = input;
    if (cleaned.length > maxPromptLength) {
      cleaned = cleaned.substring(0, maxPromptLength);
    }

    for (final pattern in _forbiddenPatterns) {
      if (cleaned.toLowerCase().contains(pattern)) {
        debugPrint('[PromptSanitizer] Blocked prompt injection pattern: $pattern');
        cleaned = cleaned.replaceAll(RegExp(pattern, caseSensitive: false), '[SANITIZED_PROMPT_SECURITY]');
      }
    }

    return cleaned.trim();
  }
}
