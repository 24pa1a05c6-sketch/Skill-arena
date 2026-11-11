import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';

/// Realtime Arena Global Chat UI Sheet.
class GlobalChatSheet extends StatefulWidget {
  const GlobalChatSheet({super.key});

  @override
  State<GlobalChatSheet> createState() => _GlobalChatSheetState();
}

class _GlobalChatSheetState extends State<GlobalChatSheet> {
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'user': 'Alex_Vanguard', 'text': 'Anyone ready for 1v1 Flutter Architecture battle?', 'time': '12:40 PM'},
    {'user': 'CyberNinja', 'text': 'Grand Finals starting in 10 mins! 🚀', 'time': '12:42 PM'},
    {'user': 'CodeQueen', 'text': 'Just completed DSA Graph Module! +500 XP 🎉', 'time': '12:44 PM'},
  ];

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.cyberBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('GLOBAL ARENA CHAT 🌐', style: AppTypography.heading3),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (ctx, idx) {
                  final msg = _messages[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: SkillGlassCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkillAvatar(initials: msg['user']!.substring(0, 2), size: 32),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(msg['user']!, style: AppTypography.labelLarge.copyWith(color: AppColors.neonCyan)),
                                    Text(msg['time']!, style: AppTypography.cyberMonoSmall),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(msg['text']!, style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Message Input
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
                      controller: _msgController,
                      style: AppTypography.bodySmall,
                      decoration: const InputDecoration(
                        hintText: 'Type global arena message...',
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.neonCyan),
                  onPressed: () {
                    if (_msgController.text.isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'user': 'YOU',
                          'text': _msgController.text,
                          'time': '12:45 PM',
                        });
                        _msgController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
