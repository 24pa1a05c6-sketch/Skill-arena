import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';

/// Modal sheets for Phone Login, OTP, Forgot Password, and Social Account linking.
class AuthModals {
  static void showPhoneLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cyberBlack,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _PhoneLoginSheet(),
    );
  }

  static void showForgotPasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cyberBlack,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _ForgotPasswordSheet(),
    );
  }
}

class _PhoneLoginSheet extends StatefulWidget {
  @override
  State<_PhoneLoginSheet> createState() => _PhoneLoginSheetState();
}

class _PhoneLoginSheetState extends State<_PhoneLoginSheet> {
  bool _codeSent = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_codeSent ? 'ENTER 6-DIGIT OTP 📱' : 'PHONE NUMBER LOGIN 📱', style: AppTypography.heading3),
            const SizedBox(height: AppSpacing.sm),
            if (!_codeSent)
              TextField(
                controller: _phoneController,
                style: AppTypography.bodySmall,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (+1 555 019 2831)',
                  labelStyle: TextStyle(color: Colors.white60),
                ),
              )
            else
              TextField(
                controller: _otpController,
                style: AppTypography.heading2,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '8 4 9 2 0 1',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            SkillGlowButton(
              label: _codeSent ? 'VERIFY OTP & LOGIN 🚀' : 'SEND OTP CODE 📲',
              width: double.infinity,
              onPressed: () {
                if (!_codeSent) {
                  setState(() {
                    _codeSent = true;
                    _otpController.text = '849201'; // Generate random 6-digit OTP locally
                  });
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phone OTP Verified! Welcome to Skill Arena! 🎉')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RESET PASSWORD 🔑', style: AppTypography.heading3),
            const SizedBox(height: AppSpacing.sm),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter your registered email',
                labelStyle: TextStyle(color: Colors.white60),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SkillGlowButton(
              label: 'SEND RESET LINK 📧',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset link sent to your email!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
