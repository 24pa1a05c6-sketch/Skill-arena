import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/features/social/presentation/providers/social_provider.dart';
import 'package:skill_arena/features/social/presentation/widgets/friends_list_sheet.dart';
import 'package:skill_arena/features/social/presentation/widgets/global_chat_sheet.dart';
import 'package:skill_arena/features/social/presentation/widgets/guild_creation_dialog.dart';
import 'package:skill_arena/features/social/presentation/widgets/guild_hall_sheet.dart';
import 'package:skill_arena/features/tournament_engine/presentation/widgets/organizer_dashboard_sheet.dart';

/// ARENA HUB — Specialized Skill & Competition Community Hub.
class ArenaHubScreen extends ConsumerStatefulWidget {
  const ArenaHubScreen({super.key});

  @override
  ConsumerState<ArenaHubScreen> createState() => _ArenaHubScreenState();
}

class _ArenaHubScreenState extends ConsumerState<ArenaHubScreen> {
  String _selectedChannel = '#general';

  final List<String> _channels = [
    '#general',
    '#tournament-chat',
    '#strategy',
    '#recruitment',
    '#coding-drills',
    '#achievements',
  ];

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialProvider);

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('ARENA HUB ⚔️', style: AppTypography.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt_rounded, color: AppColors.neonCyan),
            tooltip: 'Friends & Squad',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const FriendsListSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shield_rounded, color: AppColors.cyberAmber),
            tooltip: 'Guild Hall',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const GuildHallSheet(),
              );
            },
          ),
        ],
      ),
      body: AuroraBackground(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Guild Spotlight Card
            _buildGuildBanner(context, socialState),
            const SizedBox(height: AppSpacing.lg),

            // Arena Hub Quick Action Hub
            Text('ARENA ACTIONS', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            _buildArenaActionRow(context),
            const SizedBox(height: AppSpacing.lg),

            // Channel Filter Selector
            Text('COMMUNITY CHANNELS', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            _buildChannelSelector(),
            const SizedBox(height: AppSpacing.md),

            // Active Community Feed
            _buildFeedSection(context, socialState),
          ],
        ),
      ),
    );
  }

  Widget _buildGuildBanner(BuildContext context, SocialState state) {
    final guild = state.guilds.isNotEmpty ? state.guilds.first : null;

    return SkillGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_rounded, color: AppColors.cyberAmber, size: 28),
                  const SizedBox(width: AppSpacing.xs),
                  Text(guild?.name ?? '⚔️ NIGHT RAIDERS', style: AppTypography.heading2),
                ],
              ),
              SkillBadge(
                label: 'ELO ${guild?.eloScore ?? 1842}',
                variant: SkillBadgeVariant.premium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Members: ${guild?.membersCount ?? 128} | Global Rank #4 | Wins: 73',
            style: AppTypography.cyberMonoSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SkillGlowButton(
                  label: 'GUILD HALL 🛡️',
                  size: SkillButtonSize.small,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => const GuildHallSheet(),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: SkillGlowButton(
                  label: '+ CREATE GUILD',
                  size: SkillButtonSize.small,
                  variant: SkillButtonVariant.secondary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const GuildCreationDialog(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArenaActionRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton(
            context,
            label: 'CREATE TOURNAMENT',
            icon: Icons.add_circle_outline_rounded,
            color: AppColors.cyberAmber,
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const OrganizerDashboardSheet(),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildActionButton(
            context,
            label: 'RECRUIT PLAYER',
            icon: Icons.person_add_alt_1_rounded,
            color: AppColors.neonCyan,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recruitment ping broadcasted to Arena Hub!')),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildActionButton(
            context,
            label: 'FIND TEAMMATES',
            icon: Icons.group_add_rounded,
            color: AppColors.synthEmerald,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Searching for online squad members matching your ELO...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SkillGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: AppTypography.labelLarge.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _channels.map((ch) {
          final isSelected = _selectedChannel == ch;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: GestureDetector(
              onTap: () => setState(() => _selectedChannel = ch),
              child: SkillBadge(
                label: ch,
                variant: isSelected ? SkillBadgeVariant.info : SkillBadgeVariant.premium,
                isSmall: true,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedSection(BuildContext context, SocialState state) {
    return Column(
      children: [
        SkillGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ACTIVE DISCUSSIONS in $_selectedChannel', style: AppTypography.labelLarge),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.neonCyan),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const GlobalChatSheet(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              _buildPostItem('Vanguard_Prime', 'Just completed Live Coding Drill #42! +50 ELO points awarded.', '2m ago'),
              const Divider(color: Colors.white10),
              _buildPostItem('CyberArchitect', 'Looking for 2 teammates for the Valorant Cyber Championship this Saturday.', '14m ago'),
              const Divider(color: Colors.white10),
              _buildPostItem('AURA_Bot', 'System Announcement: Grand Finals bracket starting in 45 minutes.', '1h ago'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem(String author, String text, String timeAgo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkillAvatar(initials: 'VA', size: 36),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(author, style: AppTypography.labelLarge.copyWith(color: AppColors.neonCyan)),
                    Text(timeAgo, style: AppTypography.cyberMonoSmall),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(text, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
