import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_input.dart';
import '../../design_system/components/app_navigation.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Reset Password',
        onBackPressed: () => context.go('/auth/signin'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: DesignTokens.accent1.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusXLarge,
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 40,
                    color: DesignTokens.accent1,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing6),
                // Title
                Text(
                  _emailSent ? 'Check Your Email' : 'Forgot Password?',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacing2),
                Text(
                  _emailSent
                      ? 'We\'ve sent a password reset link to your email address'
                      : 'Enter your email address and we\'ll send you a link to reset your password',
                  style: AppTextStyles.body.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacing8),
                if (!_emailSent) ...[
                  // Email input
                  AppInput(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacing6),
                  // Send reset link button
                  AppButton(
                    text: 'Send Reset Link',
                    onPressed: _isLoading ? null : _handleSendResetLink,
                    isLoading: _isLoading,
                  ),
                ] else ...[
                  // Success message
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacing4),
                    decoration: BoxDecoration(
                      color: DesignTokens.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMedium,
                      ),
                      border: Border.all(
                        color: DesignTokens.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: DesignTokens.success,
                          size: 24,
                        ),
                        const SizedBox(width: DesignTokens.spacing3),
                        Expanded(
                          child: Text(
                            'Password reset link sent to ${_emailController.text}',
                            style: AppTextStyles.body.copyWith(
                              color: DesignTokens.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacing6),
                  // Resend button
                  AppButton(
                    text: 'Resend Email',
                    onPressed: _isLoading ? null : _handleResendEmail,
                    isLoading: _isLoading,
                    variant: AppButtonVariant.secondary,
                  ),
                ],
                const Spacer(),
                // Back to sign in
                TextButton(
                  onPressed: () => context.go('/auth/signin'),
                  child: Text(
                    'Back to Sign In',
                    style: AppTextStyles.body.copyWith(
                      color: DesignTokens.accent1,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implement actual password reset logic
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          setState(() {
            _emailSent = true;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send reset email: ${e.toString()}'),
              backgroundColor: DesignTokens.error,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _handleResendEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement resend email logic
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset email sent again'),
            backgroundColor: DesignTokens.success,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend email: ${e.toString()}'),
            backgroundColor: DesignTokens.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
