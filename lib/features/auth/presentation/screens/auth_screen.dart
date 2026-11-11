import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';
import 'package:skill_arena/core/theme/tokens/app_spacing.dart';
import 'package:skill_arena/core/theme/tokens/app_typography.dart';
import 'package:skill_arena/core/widgets/aurora_background.dart';
import 'package:skill_arena/core/widgets/skill_glass_card.dart';
import 'package:skill_arena/core/widgets/skill_glow_button.dart';
import 'package:skill_arena/core/widgets/skill_input_field.dart';
import 'package:skill_arena/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_arena/features/auth/presentation/widgets/auth_modals.dart';
import 'package:skill_arena/features/onboarding/presentation/widgets/particle_canvas.dart';

/// Cyber-themed Authentication Gateway Screen.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLogin = true;
  bool _rememberMe = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/nexus');
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.deepSpaceObsidian,
      body: AuroraBackground(
        child: Stack(
          children: [
            const ParticleCanvas(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: SkillGlassCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isLogin ? 'ACCESS TERMINAL' : 'INITIALIZE SYSTEM',
                        style: AppTypography.heading2,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _isLogin ? 'Authenticate Neural Credentials' : 'Create Vanguard Profile',
                        style: AppTypography.cyberMonoSmall,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (!_isLogin) ...[
                        SkillInputField(
                          label: 'Codename',
                          hint: 'Enter your arena handle',
                          controller: _nameController,
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.neonCyan),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      SkillInputField(
                        label: 'Neural Link (Email)',
                        hint: 'vanguard@skillarena.io',
                        controller: _emailController,
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.neonCyan),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SkillInputField(
                        label: 'Passphrase',
                        hint: '••••••••',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.neonCyan),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: AppColors.electricBlue,
                                onChanged: (val) {
                                  setState(() => _rememberMe = val ?? true);
                                },
                              ),
                              Text('Remember', style: AppTypography.bodySmall),
                            ],
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () => AuthModals.showForgotPasswordSheet(context),
                              child: Text('Forgot Password?', style: AppTypography.cyberMonoSmall.copyWith(color: AppColors.neonCyan), overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SkillGlowButton(
                        label: authState.status == AuthStatus.loading
                            ? 'AUTHORIZING...'
                            : _isLogin
                                ? 'AUTHORIZE'
                                : 'REGISTER VANGUARD',
                        size: SkillButtonSize.large,
                        width: double.infinity,
                        isLoading: authState.status == AuthStatus.loading,
                        onPressed: () {
                          if (_isLogin) {
                            ref.read(authProvider.notifier).loginWithEmail(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          } else {
                            ref.read(authProvider.notifier).registerWithEmail(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: SkillGlowButton(
                              label: 'SIGN IN WITH GOOGLE',
                              variant: SkillButtonVariant.secondary,
                              icon: Icons.g_mobiledata_rounded,
                              onPressed: () {
                                ref.read(authProvider.notifier).loginWithGoogle();
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: SkillGlowButton(
                              label: 'PHONE OTP',
                              variant: SkillButtonVariant.secondary,
                              icon: Icons.phone_android_rounded,
                              onPressed: () => AuthModals.showPhoneLoginSheet(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).loginAsGuest();
                        },
                        child: Text(
                          'CONTINUE AS GUEST 👤',
                          style: AppTypography.cyberMono.copyWith(
                            color: AppColors.neonCyan,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? 'New to the Arena?' : 'Already registered?',
                            style: AppTypography.bodySmall,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? 'CREATE ACCOUNT' : 'LOGIN',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.electricBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
