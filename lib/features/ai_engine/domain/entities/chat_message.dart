import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant, system }

/// Persistent AI Mentor Chat Message model.
class ChatMessage extends Equatable {
  final String id;
  final String sessionId;
  final MessageRole role;
  final String text;
  final DateTime timestamp;
  final List<String> suggestions;

  const ChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.text,
    required this.timestamp,
    this.suggestions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionId': sessionId,
      'role': role.name,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'suggestions': suggestions,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String? ?? '',
      sessionId: map['sessionId'] as String? ?? 'default_session',
      role: MessageRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => MessageRole.assistant,
      ),
      text: map['text'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
      suggestions: (map['suggestions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [id, sessionId, role, text, timestamp];
}
