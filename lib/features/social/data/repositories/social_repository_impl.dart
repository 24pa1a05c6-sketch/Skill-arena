import 'package:skill_arena/features/social/data/datasources/firestore_social_datasource.dart';
import 'package:skill_arena/features/social/domain/entities/chat_message_model.dart';
import 'package:skill_arena/features/social/domain/entities/friend_model.dart';
import 'package:skill_arena/features/social/domain/entities/guild_model.dart';
import 'package:skill_arena/features/social/domain/repositories/social_repository.dart';

/// Implementation of [SocialRepository].
class SocialRepositoryImpl implements SocialRepository {
  final FirestoreSocialDatasource _datasource;

  SocialRepositoryImpl(this._datasource);

  @override
  Future<List<GuildModel>> getGuilds() {
    return _datasource.getGuilds();
  }

  @override
  Future<GuildModel> createGuild({
    required String name,
    required String tag,
    required String description,
  }) {
    return _datasource.createGuild(name: name, tag: tag, description: description);
  }

  @override
  Future<void> joinGuild(String guildId, String userId) {
    return _datasource.joinGuild(guildId, userId);
  }

  @override
  Future<List<FriendModel>> getFriends(String userId) {
    return _datasource.getFriends(userId);
  }

  @override
  Future<void> sendFriendRequest(String fromUserId, String toUserId) {
    return _datasource.sendFriendRequest(fromUserId, toUserId);
  }

  @override
  Future<void> acceptFriendRequest(String requestId) {
    return _datasource.acceptFriendRequest(requestId);
  }

  @override
  Future<void> updatePresence(String userId, UserPresenceStatus status) {
    return _datasource.updatePresence(userId, status);
  }

  @override
  Future<List<SocialChatMessage>> getChatMessages(String channelId) {
    return _datasource.getChatMessages(channelId);
  }

  @override
  Future<SocialChatMessage> sendMessage({
    required String channelId,
    required String senderId,
    required String senderName,
    required String content,
  }) {
    return _datasource.sendMessage(
      channelId: channelId,
      senderId: senderId,
      senderName: senderName,
      content: content,
    );
  }

  @override
  Future<Map<String, List<dynamic>>> globalSearch(String query) {
    return _datasource.globalSearch(query);
  }
}
