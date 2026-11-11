import 'package:equatable/equatable.dart';

class UserSummary extends Equatable {
  const UserSummary({
    required this.name,
    required this.level,
    required this.xp,
    required this.targetXp,
    required this.tokens,
  });

  final String name;
  final int level;
  final int xp;
  final int targetXp;
  final int tokens;

  @override
  List<Object?> get props => [name, level, xp, targetXp, tokens];
}

class LiveTournamentSpotlight extends Equatable {
  const LiveTournamentSpotlight({
    required this.title,
    required this.prizePool,
    required this.timeRemaining,
    required this.participantCount,
  });

  final String title;
  final int prizePool;
  final String timeRemaining;
  final int participantCount;

  @override
  List<Object?> get props => [title, prizePool, timeRemaining, participantCount];
}

class QuickAction extends Equatable {
  const QuickAction({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final String icon; // Could be an icon name or path
  final String route;

  @override
  List<Object?> get props => [title, icon, route];
}

class ActivityItem extends Equatable {
  const ActivityItem({
    required this.user,
    required this.action,
    required this.timeAgo,
  });

  final String user;
  final String action;
  final String timeAgo;

  @override
  List<Object?> get props => [user, action, timeAgo];
}

class NexusDashboardData extends Equatable {
  const NexusDashboardData({
    required this.userSummary,
    required this.spotlight,
    required this.quickActions,
    required this.activityFeed,
  });

  final UserSummary userSummary;
  final LiveTournamentSpotlight spotlight;
  final List<QuickAction> quickActions;
  final List<ActivityItem> activityFeed;

  @override
  List<Object?> get props => [userSummary, spotlight, quickActions, activityFeed];
}
