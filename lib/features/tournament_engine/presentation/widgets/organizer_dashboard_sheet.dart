import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_input_field.dart';

/// Tournament Organizer Creation & Management Wizard.
class OrganizerDashboardSheet extends StatefulWidget {
  const OrganizerDashboardSheet({super.key});

  @override
  State<OrganizerDashboardSheet> createState() => _OrganizerDashboardSheetState();
}

class _OrganizerDashboardSheetState extends State<OrganizerDashboardSheet> {
  final _titleController = TextEditingController();
  final _entryFeeController = TextEditingController(text: '100');
  final _prizePoolController = TextEditingController(text: '10,000');
  final _maxParticipantsController = TextEditingController(text: '128');

  String _selectedGame = 'Valorant';
  String _format = 'Single Elimination';
  bool _isCreated = false;

  final List<String> _games = ['Valorant', 'Flutter Battle', 'CyberSec CTF', 'DSA Championship', 'Web3 Hackathon'];
  final List<String> _formats = ['Single Elimination', 'Double Elimination', 'Swiss System', 'Round Robin'];

  @override
  void dispose() {
    _titleController.dispose();
    _entryFeeController.dispose();
    _prizePoolController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.cyberBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          children: [
            // Sheet Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ORGANIZER PLATFORM 🏆', style: AppTypography.heading3),
                      Text('Host & Manage Enterprise Tournaments', style: AppTypography.cyberMonoSmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: ListView(
                children: [
                  // Regulatory Compliance Notice Card
                  SkillGlassCard(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.gavel_rounded, color: AppColors.cyberAmber, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Regulatory Compliance: Real-money prizes require organizer verification.',
                            style: AppTypography.cyberMonoSmall.copyWith(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Tournament Title
                  SkillInputField(
                    label: 'Tournament Title',
                    hint: 'e.g. Valorant Vanguard Championship 2030',
                    controller: _titleController,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Game / Category Dropdown
                  Text('GAME / TRACK', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _games.map((g) {
                        final isSelected = _selectedGame == g;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedGame = g),
                            child: SkillBadge(
                              label: g,
                              variant: isSelected ? SkillBadgeVariant.info : SkillBadgeVariant.premium,
                              isSmall: true,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Format Selector
                  Text('BRACKET FORMAT', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _formats.map((f) {
                        final isSelected = _format == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: GestureDetector(
                            onTap: () => setState(() => _format = f),
                            child: SkillBadge(
                              label: f,
                              variant: isSelected ? SkillBadgeVariant.live : SkillBadgeVariant.info,
                              isSmall: true,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Financial Parameters
                  Row(
                    children: [
                      Expanded(
                        child: SkillInputField(
                          label: 'Entry Fee (\$ARENA)',
                          controller: _entryFeeController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: SkillInputField(
                          label: 'Prize Pool (\$ARENA)',
                          controller: _prizePoolController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Participant Cap
                  SkillInputField(
                    label: 'Max Competitors Cap',
                    controller: _maxParticipantsController,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  if (_isCreated)
                    SkillGlassCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.synthEmerald, size: 36),
                          const SizedBox(height: AppSpacing.xs),
                          Text('TOURNAMENT PUBLISHED! 🎉', style: AppTypography.heading3),
                          Text('Matchmaking & bracket check-in link active.', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Submit Button
            SkillGlowButton(
              label: _isCreated ? 'VIEW ORGANIZER DASHBOARD 📊' : 'PUBLISH TO ARENA 🚀',
              width: double.infinity,
              onPressed: () {
                setState(() => _isCreated = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tournament published to Battle Grid! Check-in open.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
