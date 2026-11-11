import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Interactive Video Lesson Player UI with video progress timeline, notes, & bookmarks.
class CourseVideoLessonSheet extends StatefulWidget {
  final String courseTitle;
  final String lessonTitle;

  const CourseVideoLessonSheet({
    super.key,
    required this.courseTitle,
    required this.lessonTitle,
  });

  @override
  State<CourseVideoLessonSheet> createState() => _CourseVideoLessonSheetState();
}

class _CourseVideoLessonSheetState extends State<CourseVideoLessonSheet> {
  bool _isPlaying = false;
  double _videoProgress = 0.35;
  bool _isBookmarked = false;
  final TextEditingController _noteController = TextEditingController();
  final List<String> _notes = ['Key Takeaway: Use Riverpod StateNotifier for clean state separation.'];

  @override
  void dispose() {
    _noteController.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sheet Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.lessonTitle, style: AppTypography.heading3, overflow: TextOverflow.ellipsis),
                      Text(widget.courseTitle, style: AppTypography.cyberMonoSmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: AppColors.neonCyan),
                  onPressed: () {
                    setState(() {
                      _isBookmarked = !_isBookmarked;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_isBookmarked ? 'Bookmarked lesson!' : 'Removed bookmark.')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Video Simulation Player Container
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.electricBlue.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricBlue.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cyber Grid BG
                  const Positioned.fill(
                    child: Center(
                      child: Icon(Icons.play_circle_outline_rounded, size: 64, color: AppColors.neonCyan),
                    ),
                  ),

                  // Overlay Controls
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      children: [
                        SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 3,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                            activeTrackColor: AppColors.neonCyan,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            value: _videoProgress,
                            onChanged: (val) {
                              setState(() {
                                _videoProgress = val;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(_videoProgress * 15).toStringAsFixed(1)}m / 15.0m',
                              style: AppTypography.cyberMonoSmall,
                            ),
                            IconButton(
                              icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Lesson Notes Section
            Text('LESSON NOTES & BOOKMARKS 📝', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: ListView(
                children: [
                  SkillGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _noteController,
                                style: AppTypography.bodySmall,
                                decoration: const InputDecoration(
                                  hintText: 'Add timestamp note...',
                                  hintStyle: TextStyle(color: Colors.white38),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send_rounded, color: AppColors.neonCyan),
                              onPressed: () {
                                if (_noteController.text.isNotEmpty) {
                                  setState(() {
                                    _notes.add(_noteController.text);
                                    _noteController.clear();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ..._notes.map((note) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: SkillGlassCard(
                          child: Row(
                            children: [
                              const Icon(Icons.sticky_note_2_rounded, size: 16, color: AppColors.cyberAmber),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(child: Text(note, style: AppTypography.bodySmall)),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),

            // Next Lesson Action
            SkillGlowButton(
              label: 'MARK LESSON COMPLETE & NEXT 🚀',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lesson completed! +100 XP Earned! 🎉')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
