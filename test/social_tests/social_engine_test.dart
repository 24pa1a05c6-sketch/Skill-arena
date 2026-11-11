import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_arena/features/social/data/datasources/firestore_social_datasource.dart';
import 'package:skill_arena/features/social/domain/entities/chat_message_model.dart';
import 'package:skill_arena/features/social/domain/entities/friend_model.dart';
import 'package:skill_arena/features/social/domain/entities/guild_model.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 7 Social Ecosystem & Guild Engine Unit Tests', () {
    test('GuildModel serialization and property equality', () {
      const guild = GuildModel(
        id: 'g100',
        name: 'Vanguard Alpha',
        tag: 'VALP',
        description: 'Elite Competitive Guild',
        leaderId: 'usr_alpha',
        level: 10,
        xp: 250000,
      );

      final map = guild.toMap();
      final restored = GuildModel.fromMap(map);

      expect(restored.id, equals('g100'));
      expect(restored.name, equals('Vanguard Alpha'));
      expect(restored.level, equals(10));
    });

    test('FriendModel presence and status mapping', () {
      final friend = FriendModel(
        userId: 'usr_f1',
        userName: 'Aria Sterling',
        rankTier: 'DIAMOND',
        presence: UserPresenceStatus.inMatch,
        lastSeen: DateTime.now(),
      );

      expect(friend.presence, equals(UserPresenceStatus.inMatch));
      expect(friend.status, equals(FriendStatus.friend));
    });

    test('SocialChatMessage serialization and reactions', () {
      final msg = SocialChatMessage(
        id: 'msg_1',
        channelId: 'g1',
        senderId: 'usr_1',
        senderName: 'Vanguard One',
        content: 'Arena finals are live!',
        timestamp: DateTime.now(),
        reactions: const {'🔥': 10, '🚀': 5},
      );

      expect(msg.reactions['🔥'], equals(10));
      expect(msg.channelType, equals(ChatChannelType.guild));
    });

    test('FirestoreSocialDatasource fetches guilds and creates new guild', () async {
      final ds = FirestoreSocialDatasource();
      final guilds = await ds.getGuilds();

      expect(guilds.length, greaterThanOrEqualTo(3));
      expect(guilds.first.name, equals('Cyber Vanguards'));

      final newGuild = await ds.createGuild(
        name: 'Quantum Cyber',
        tag: 'QCYB',
        description: 'Quantum Software Engineering Squad',
      );

      expect(newGuild.name, equals('Quantum Cyber'));
      expect(newGuild.tag, equals('QCYB'));
    });

    test('FirestoreSocialDatasource performs global search', () async {
      final ds = FirestoreSocialDatasource();
      final results = await ds.globalSearch('vanguard');

      expect(results.containsKey('players'), isTrue);
      expect(results.containsKey('guilds'), isTrue);
      expect(results.containsKey('courses'), isTrue);
    });
  });
}
