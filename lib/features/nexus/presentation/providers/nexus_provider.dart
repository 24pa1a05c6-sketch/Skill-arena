import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/nexus/domain/entities/nexus_dashboard_data.dart';

final nexusDashboardProvider = FutureProvider<NexusDashboardData>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));

  return const NexusDashboardData(
    userSummary: UserSummary(
      name: 'Cyber Vanguard',
      level: 12,
      xp: 4850,
      targetXp: 5000,
      tokens: 1250,
    ),
    spotlight: LiveTournamentSpotlight(
      title: 'Cyber Battle Royale',
      prizePool: 10000,
      timeRemaining: '02:14:30',
      participantCount: 1420,
    ),
    quickActions: [
      QuickAction(title: 'Join Tournament', icon: 'sword', route: '/tournaments'),
      QuickAction(title: 'Skill Trees', icon: 'tree', route: '/skills'),
      QuickAction(title: 'My Profile', icon: 'user', route: '/profile'),
      QuickAction(title: 'Component Catalog', icon: 'grid', route: '/catalog'),
    ],
    activityFeed: [
      ActivityItem(user: 'NeonKnight', action: 'Unlocked Master Flutter badge', timeAgo: '2m ago'),
      ActivityItem(user: 'SyntaxError', action: 'Joined Cyber Battle Royale', timeAgo: '15m ago'),
    ],
  );
});
