import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_durations.dart';
import 'package:skill_arena/core/theme/tokens/app_radius.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';

class SkillInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? successText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enabled;
  final bool isLoading;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final FocusNode? focusNode;

  const SkillInputField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.successText,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.isLoading = false,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.focusNode,
  });

  @override
  State<SkillInputField> createState() => _SkillInputFieldState();
}

class _SkillInputFieldState extends State<SkillInputField> {
  late FocusNode _focusNode;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final bool hasSuccess = widget.successText != null && widget.successText!.isNotEmpty;
    final bool isFocused = _focusNode.hasFocus;

    Color borderColor = const Color.fromRGBO(255, 255, 255, 0.08);
    double borderWidth = 1.0;
    List<BoxShadow>? boxShadow;

    if (hasError) {
      borderColor = AppColors.coralBurst;
    } else if (hasSuccess) {
      borderColor = AppColors.synthEmerald;
    } else if (isFocused) {
      borderColor = AppColors.electricBlue;
      borderWidth = 1.5;
      boxShadow = [
        BoxShadow(
          color: AppColors.electricBlue.withValues(alpha: 0.2),
          blurRadius: 8,
          spreadRadius: 1,
        )
      ];
    } else if (_isHovered) {
      borderColor = const Color.fromRGBO(255, 255, 255, 0.15);
    }

    return Semantics(
      label: widget.label ?? widget.hint ?? 'Input field',
      enabled: widget.enabled,
      textField: true,
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                decoration: BoxDecoration(
                  color: AppColors.cyberBlack,
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(
                    color: borderColor,
                    width: borderWidth,
                  ),
                  boxShadow: boxShadow,
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.sm),
                        child: widget.prefixIcon,
                      ),
                    Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        obscureText: widget.obscureText,
                        enabled: widget.enabled && !widget.isLoading,
                        keyboardType: widget.keyboardType,
                        onChanged: widget.onChanged,
                        onEditingComplete: widget.onEditingComplete,
                        maxLines: widget.maxLines,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.sm,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    if (widget.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(right: AppSpacing.sm),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.electricBlue),
                          ),
                        ),
                      )
                    else if (widget.suffixIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: widget.suffixIcon,
                      ),
                  ],
                ),
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.errorText!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.coralBurst,
                ),
              ),
            ] else if (hasSuccess) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.successText!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.synthEmerald,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
