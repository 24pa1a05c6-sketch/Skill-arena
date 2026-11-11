import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_avatar.dart';
import 'package:skill_arena/core/widgets/skill_badge.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_input_field.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/chat_message.dart';
import 'package:skill_arena/features/ai_engine/presentation/providers/ai_engine_provider.dart';

/// Reusable Cyber AI Mentor Chat Modal Sheet.
class AiMentorChatSheet extends ConsumerStatefulWidget {
  const AiMentorChatSheet({super.key});

  @override
  ConsumerState<AiMentorChatSheet> createState() => _AiMentorChatSheetState();
}

class _AiMentorChatSheetState extends ConsumerState<AiMentorChatSheet> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiEngineProvider);
    final notifier = ref.read(aiEngineProvider.notifier);

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
            // Header
            Row(
              children: [
                const SkillAvatar(
                  initials: 'AI',
                  size: 40,
                  showStatusRing: true,
                  status: SkillAvatarStatus.online,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AURA AI MENTOR 🤖', style: AppTypography.heading3),
                      Text('Growth Acceleration Engine Active', style: AppTypography.cyberMonoSmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: AppColors.neonCyan),
                  tooltip: 'New Chat Session',
                  onPressed: () {
                    notifier.clearHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Started a new AURA conversation session!')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            // Production AI Config Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.3)),
              ),
              child: Text(
                '⚡ Production AI activates automatically after backend configuration.',
                style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Chat Messages List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                itemCount: state.chatMessages.length,
                itemBuilder: (ctx, index) {
                  final msg = state.chatMessages[index];
                  final isUser = msg.role == MessageRole.user;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: SkillGlassCard(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isUser ? 'YOU' : 'AURA AI',
                                  style: AppTypography.cyberMonoSmall.copyWith(
                                    color: isUser ? AppColors.neonCyan : AppColors.cyberAmber,
                                  ),
                                ),
                                if (!isUser)
                                  const SkillBadge(label: 'ENTERPRISE LLM', variant: SkillBadgeVariant.premium, isSmall: true),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(msg.text, style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Prompt Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPromptChip('Analyze Skill Gap 📊', notifier),
                  const SizedBox(width: AppSpacing.xs),
                  _buildPromptChip('Generate Roadmap 🗺️', notifier),
                  const SizedBox(width: AppSpacing.xs),
                  _buildPromptChip('Code Review ⚡', notifier),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Input Bar
            Row(
              children: [
                Expanded(
                  child: SkillInputField(
                    controller: _textController,
                    hint: 'Ask AURA anything about skills or career...',
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                SkillGlowButton(
                  label: 'SEND',
                  isLoading: state.isSending,
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty) {
                      notifier.sendMessage(_textController.text);
                      _textController.clear();
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

  Widget _buildPromptChip(String text, AiEngineNotifier notifier) {
    return GestureDetector(
      onTap: () {
        notifier.sendMessage(text);
      },
      child: SkillBadge(
        label: text,
        variant: SkillBadgeVariant.info,
        isSmall: true,
      ),
    );
  }
}
