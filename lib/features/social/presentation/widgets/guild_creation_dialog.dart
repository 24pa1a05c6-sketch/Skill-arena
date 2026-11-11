import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Guild Creation Dialog.
class GuildCreationDialog extends StatefulWidget {
  const GuildCreationDialog({super.key});

  @override
  State<GuildCreationDialog> createState() => _GuildCreationDialogState();
}

class _GuildCreationDialogState extends State<GuildCreationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cyberBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FOUND NEW GUILD 🛡️', style: AppTypography.heading3),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _nameController,
              style: AppTypography.bodySmall,
              decoration: const InputDecoration(
                labelText: 'Guild Name (e.g. Cyber Vanguard)',
                labelStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _tagController,
              style: AppTypography.bodySmall,
              decoration: const InputDecoration(
                labelText: 'Cyber Tag (e.g. VNGD)',
                labelStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SkillGlowButton(
              label: 'CREATE GUILD (500 \$ARENA) 🚀',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Guild "${_nameController.text}" created successfully! 🎉')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
