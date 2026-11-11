import 'package:skill_arena/features/social/domain/entities/chat_message_model.dart';
import 'package:skill_arena/features/social/domain/entities/friend_model.dart';
import 'package:skill_arena/features/social/domain/entities/guild_model.dart';

/// Repository contract for Phase 7 Social Ecosystem, Guilds & Realtime Networking Engine.
abstract class SocialRepository {
  /// Fetches available guilds.
  Future<List<GuildModel>> getGuilds();

  /// Creates a new Guild.
  Future<GuildModel> createGuild({
    required String name,
    required String tag,
    required String description,
  });

  /// Joins a Guild.
  Future<void> joinGuild(String guildId, String userId);

  /// Fetches friends list for user.
  Future<List<FriendModel>> getFriends(String userId);

  /// Sends a friend request.
  Future<void> sendFriendRequest(String fromUserId, String toUserId);

  /// Accepts a friend request.
  Future<void> acceptFriendRequest(String requestId);

  /// Updates user live presence status.
  Future<void> updatePresence(String userId, UserPresenceStatus status);

  /// Fetches real-time chat messages for channel.
  Future<List<SocialChatMessage>> getChatMessages(String channelId);

  /// Sends a real-time message to chat channel.
  Future<SocialChatMessage> sendMessage({
    required String channelId,
    required String senderId,
    required String senderName,
    required String content,
  });

  /// Global Search across Players, Guilds, Courses, Tournaments.
  Future<Map<String, List<dynamic>>> globalSearch(String query);
}
