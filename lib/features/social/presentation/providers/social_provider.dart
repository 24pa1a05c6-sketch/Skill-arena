import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/social/data/datasources/firestore_social_datasource.dart';
import 'package:skill_arena/features/social/data/repositories/social_repository_impl.dart';
import 'package:skill_arena/features/social/domain/entities/chat_message_model.dart';
import 'package:skill_arena/features/social/domain/entities/friend_model.dart';
import 'package:skill_arena/features/social/domain/entities/guild_model.dart';
import 'package:skill_arena/features/social/domain/repositories/social_repository.dart';

class SocialState {
  final List<GuildModel> guilds;
  final Set<String> joinedGuildIds;
  final List<FriendModel> friends;
  final List<SocialChatMessage> activeChatMessages;
  final UserPresenceStatus currentPresence;
  final Map<String, List<dynamic>> searchResults;
  final bool isLoading;

  const SocialState({
    this.guilds = const [],
    this.joinedGuildIds = const {'g1'},
    this.friends = const [],
    this.activeChatMessages = const [],
    this.currentPresence = UserPresenceStatus.online,
    this.searchResults = const {},
    this.isLoading = false,
  });

  SocialState copyWith({
    List<GuildModel>? guilds,
    Set<String>? joinedGuildIds,
    List<FriendModel>? friends,
    List<SocialChatMessage>? activeChatMessages,
    UserPresenceStatus? currentPresence,
    Map<String, List<dynamic>>? searchResults,
    bool? isLoading,
  }) {
    return SocialState(
      guilds: guilds ?? this.guilds,
      joinedGuildIds: joinedGuildIds ?? this.joinedGuildIds,
      friends: friends ?? this.friends,
      activeChatMessages: activeChatMessages ?? this.activeChatMessages,
      currentPresence: currentPresence ?? this.currentPresence,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final firestoreSocialDatasourceProvider = Provider<FirestoreSocialDatasource>((ref) {
  return FirestoreSocialDatasource();
});

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final ds = ref.watch(firestoreSocialDatasourceProvider);
  return SocialRepositoryImpl(ds);
});

final socialProvider = StateNotifierProvider<SocialNotifier, SocialState>((ref) {
  final repo = ref.watch(socialRepositoryProvider);
  return SocialNotifier(repo);
});

class SocialNotifier extends StateNotifier<SocialState> {
  final SocialRepository _repository;

  SocialNotifier(this._repository) : super(const SocialState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final guilds = await _repository.getGuilds();
    final friends = await _repository.getFriends('vanguard_2030');
    final chat = await _repository.getChatMessages('g1');

    state = state.copyWith(
      guilds: guilds,
      friends: friends,
      activeChatMessages: chat,
      isLoading: false,
    );
  }

  Future<void> joinGuild(String guildId) async {
    await _repository.joinGuild(guildId, 'vanguard_2030');
    final updated = Set<String>.from(state.joinedGuildIds)..add(guildId);
    state = state.copyWith(joinedGuildIds: updated);
  }

  Future<void> sendChatMessage(String channelId, String text) async {
    final msg = await _repository.sendMessage(
      channelId: channelId,
      senderId: 'vanguard_2030',
      senderName: 'Vanguard Architect',
      content: text,
    );
    final updated = List<SocialChatMessage>.from(state.activeChatMessages)..add(msg);
    state = state.copyWith(activeChatMessages: updated);
  }

  Future<void> updatePresence(UserPresenceStatus status) async {
    await _repository.updatePresence('vanguard_2030', status);
    state = state.copyWith(currentPresence: status);
  }

  Future<void> performGlobalSearch(String query) async {
    final results = await _repository.globalSearch(query);
    state = state.copyWith(searchResults: results);
  }
}
