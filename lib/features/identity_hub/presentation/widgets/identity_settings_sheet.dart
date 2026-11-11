import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/theme/theme_provider.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// User Identity Settings Bottom Sheet.
class IdentitySettingsSheet extends ConsumerStatefulWidget {
  const IdentitySettingsSheet({super.key});

  @override
  ConsumerState<IdentitySettingsSheet> createState() => _IdentitySettingsSheetState();
}

class _IdentitySettingsSheetState extends ConsumerState<IdentitySettingsSheet> {
  bool _pushNotifications = true;
  bool _matchInvites = true;
  bool _publicProfile = true;

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.cyberBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SETTINGS & CUSTOMIZATION ⚙️', style: AppTypography.heading3),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Expanded(
              child: ListView(
                children: [
                  // Theme Customization Selector
                  Text('THEME & DESIGN MODE', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  SkillGlassCard(
                    child: Column(
                      children: [
                        _buildThemeOption('Dark Obsidian (Default)', AppThemeMode.darkObsidian, themeState.mode, themeNotifier),
                        _buildThemeOption('Cyber Amber', AppThemeMode.cyberAmber, themeState.mode, themeNotifier),
                        _buildThemeOption('Synth Emerald', AppThemeMode.synthEmerald, themeState.mode, themeNotifier),
                        _buildThemeOption('Royal Purple', AppThemeMode.royalPurple, themeState.mode, themeNotifier),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Notifications & Privacy Toggles
                  Text('NOTIFICATIONS & PRIVACY', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  SkillGlassCard(
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: SwitchListTile(
                            title: Text('Push Notifications', style: AppTypography.bodyMedium),
                            subtitle: Text('Streak reminders & battle invites', style: AppTypography.cyberMonoSmall),
                            value: _pushNotifications,
                            activeThumbColor: AppColors.neonCyan,
                            onChanged: (val) => setState(() => _pushNotifications = val),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: SwitchListTile(
                            title: Text('Tournament Invites', style: AppTypography.bodyMedium),
                            subtitle: Text('Allow guild members to invite you', style: AppTypography.cyberMonoSmall),
                            value: _matchInvites,
                            activeThumbColor: AppColors.neonCyan,
                            onChanged: (val) => setState(() => _matchInvites = val),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: SwitchListTile(
                            title: Text('Public Profile Visibility', style: AppTypography.bodyMedium),
                            subtitle: Text('Allow recruiters to view Skill Radar', style: AppTypography.cyberMonoSmall),
                            value: _publicProfile,
                            activeThumbColor: AppColors.neonCyan,
                            onChanged: (val) => setState(() => _publicProfile = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Security Status
                  SkillGlassCard(
                    child: Row(
                      children: [
                        const Icon(Icons.shield_rounded, color: AppColors.synthEmerald, size: 28),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SECURITY INTEGRITY STATUS', style: AppTypography.labelLarge),
                              Text('AI Proctor Score: 100% SECURE • 0 Warnings', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.synthEmerald)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Logout Action Button
            SkillGlowButton(
              label: 'LOGOUT SESSION 🚪',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Session Logged Out (Local State Reset).')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label, AppThemeMode mode, AppThemeMode currentMode, ThemeNotifier notifier) {
    final isSelected = mode == currentMode;
    return InkWell(
      onTap: () => notifier.setTheme(mode),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.neonCyan : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(color: isSelected ? AppColors.neonCyan : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
