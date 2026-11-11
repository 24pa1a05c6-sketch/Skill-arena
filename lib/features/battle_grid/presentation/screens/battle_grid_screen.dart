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
import 'package:skill_arena/core/widgets/skill_input_field.dart';
import 'package:skill_arena/core/widgets/skill_skeleton_loader.dart';
import 'package:skill_arena/features/battle_grid/domain/entities/tournament.dart';
import 'package:skill_arena/features/battle_grid/presentation/providers/battle_grid_provider.dart';
import 'package:skill_arena/features/battle_grid/presentation/widgets/tournament_details_sheet.dart';
import 'package:skill_arena/features/battle_grid/presentation/widgets/tournament_match_room_sheet.dart';
import 'package:skill_arena/features/tournament_engine/presentation/providers/tournament_engine_provider.dart';
import 'package:skill_arena/features/tournament_engine/presentation/widgets/moderator_control_sheet.dart';
import 'package:skill_arena/features/tournament_engine/presentation/widgets/skill_bracket_viewer.dart';

/// Flagship Battle Grid Screen with Live Brackets & Moderator Control Hub.
class BattleGridScreen extends ConsumerWidget {
  const BattleGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(battleGridProvider);
    final notifier = ref.read(battleGridProvider.notifier);
    final tournamentEngineState = ref.watch(tournamentEngineProvider);
    final filteredTournaments = notifier.filteredTournaments;
    final topPlayers = state.leaderboard.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('BATTLE GRID', style: AppTypography.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.cyberAmber),
            tooltip: 'Organizer Hub',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const ModeratorControlSheet(tournamentId: 't1'),
              );
            },
          ),
        ],
      ),
      body: AuroraBackground(
        child: state.isLoading
            ? ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: const [
                  SkillSkeletonCard(lines: 2),
                  SizedBox(height: AppSpacing.md),
                  SkillSkeletonCard(),
                  SizedBox(height: AppSpacing.md),
                  SkillSkeletonCard(lines: 2),
                ],
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: [
                  _buildSearchAndFilter(context, state, notifier),
                  const SizedBox(height: AppSpacing.md),
                  _buildLiveBracketSection(context, tournamentEngineState),
                  const SizedBox(height: AppSpacing.lg),
                  if (topPlayers.isNotEmpty) _buildLeaderboardBanner(topPlayers),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTournamentGrid(context, filteredTournaments, state.joinedTournamentIds, notifier),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, BattleGridState state, BattleGridNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkillInputField(
          hint: 'Search tournaments by name or stack...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.neonCyan),
          onChanged: notifier.setSearchQuery,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildFilterBadge('ALL', state.selectedFilter, notifier, SkillBadgeVariant.info),
            const SizedBox(width: AppSpacing.xs),
            _buildFilterBadge('LIVE', state.selectedFilter, notifier, SkillBadgeVariant.live),
            const SizedBox(width: AppSpacing.xs),
            _buildFilterBadge('UPCOMING', state.selectedFilter, notifier, SkillBadgeVariant.warning),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveBracketSection(BuildContext context, TournamentEngineState engineState) {
    return SkillGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LIVE COMPETITIVE BRACKETS', style: AppTypography.labelLarge),
              const SkillBadge(label: 'ROUND 1', variant: SkillBadgeVariant.live, isSmall: true, showPulse: true),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 220,
            child: SkillBracketViewer(rounds: engineState.rounds),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBadge(String filter, String selectedFilter, BattleGridNotifier notifier, SkillBadgeVariant variant) {
    final isSelected = filter == selectedFilter;
    return GestureDetector(
      onTap: () => notifier.setFilter(filter),
      child: SkillBadge(
        label: filter,
        variant: isSelected ? variant : SkillBadgeVariant.info,
        isSmall: true,
        showPulse: filter == 'LIVE' && isSelected,
      ),
    );
  }

  Widget _buildLeaderboardBanner(List<Map<String, dynamic>> topPlayers) {
    return SkillGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TOP VANGUARD LEADERBOARD', style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: topPlayers.map((player) {
              return Column(
                children: [
                  const SkillAvatar(
                    initials: 'VP',
                    showStatusRing: true,
                    status: SkillAvatarStatus.online,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(player['name'] as String, style: AppTypography.labelLarge),
                  Text(
                    '${player['earnings']} \$ARENA',
                    style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.cyberAmber),
                  ),
                  Text('#${player['rank']} Global', style: AppTypography.bodySmall),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentGrid(
    BuildContext context,
    List<Tournament> tournaments,
    Set<String> joinedIds,
    BattleGridNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ACTIVE & UPCOMING TOURNAMENTS', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        ...tournaments.map((t) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _buildTournamentCard(context, t, joinedIds.contains(t.id), notifier),
          );
        }),
      ],
    );
  }

  Widget _buildTournamentCard(
    BuildContext context,
    Tournament tournament,
    bool isJoined,
    BattleGridNotifier notifier,
  ) {
    SkillBadgeVariant statusVariant = SkillBadgeVariant.info;
    if (tournament.status == 'live') statusVariant = SkillBadgeVariant.live;
    if (tournament.status == 'upcoming') statusVariant = SkillBadgeVariant.warning;

    return SkillGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(tournament.title, style: AppTypography.heading3, overflow: TextOverflow.ellipsis)),
              SkillBadge(
                label: tournament.status.toUpperCase(),
                variant: statusVariant,
                showPulse: tournament.status == 'live',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              SkillBadge(label: tournament.difficulty, variant: SkillBadgeVariant.info, isSmall: true),
              const SizedBox(width: AppSpacing.xs),
              SkillBadge(label: tournament.category, variant: SkillBadgeVariant.premium, isSmall: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prize Pool', style: AppTypography.bodySmall),
                  Text('${tournament.prizeTokens} \$ARENA', style: AppTypography.cyberMono.copyWith(color: AppColors.cyberAmber)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Registration', style: AppTypography.bodySmall),
                  Text('${tournament.participantCount}/${tournament.maxParticipants}', style: AppTypography.cyberMono),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Bracket: ${tournament.bracketRounds.join(" > ")}',
            style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.md),
          SkillGlowButton(
            label: isJoined ? 'ENTER BATTLE ROOM ⚔️' : (tournament.status == 'completed' ? 'VIEW RESULTS 🏆' : 'JOIN BATTLE 🚀'),
            variant: isJoined ? SkillButtonVariant.primary : SkillButtonVariant.secondary,
            width: double.infinity,
            onPressed: () {
              if (isJoined) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => const TournamentMatchRoomSheet(),
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => TournamentDetailsSheet(
                    title: tournament.title,
                    prizePool: '${tournament.prizeTokens} \$ARENA',
                    category: tournament.category,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
