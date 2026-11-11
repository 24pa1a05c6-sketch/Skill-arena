import 'package:equatable/equatable.dart';

enum ChatChannelType { private, guild, tournament }

class SocialChatMessage extends Equatable {
  final String id;
  final String channelId;
  final ChatChannelType channelType;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final DateTime timestamp;
  final List<String> readBy;
  final Map<String, int> reactions;
  final bool isVoiceNote;

  const SocialChatMessage({
    required this.id,
    required this.channelId,
    this.channelType = ChatChannelType.guild,
    required this.senderId,
    required this.senderName,
    this.senderAvatar = '',
    required this.content,
    required this.timestamp,
    this.readBy = const [],
    this.reactions = const {'🔥': 3, '🚀': 5},
    this.isVoiceNote = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'channelId': channelId,
      'channelType': channelType.name,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'readBy': readBy,
      'reactions': reactions,
      'isVoiceNote': isVoiceNote,
    };
  }

  factory SocialChatMessage.fromMap(Map<String, dynamic> map) {
    return SocialChatMessage(
      id: map['id'] as String? ?? '',
      channelId: map['channelId'] as String? ?? '',
      channelType: ChatChannelType.values.firstWhere((e) => e.name == map['channelType'], orElse: () => ChatChannelType.guild),
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? 'Vanguard',
      senderAvatar: map['senderAvatar'] as String? ?? '',
      content: map['content'] as String? ?? '',
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
      readBy: (map['readBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      reactions: (map['reactions'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as int)) ?? const {'🔥': 3},
      isVoiceNote: map['isVoiceNote'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, channelId, senderId, content, timestamp];
}
