import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_input.dart';
import '../../design_system/components/app_navigation.dart';
import '../../providers/auth_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: DesignTokens.brandDark,
          appBar: AppAppBarWithBack(
            title: 'Sign In',
            onBackPressed: () => context.go('/onboarding/welcome'),
          ),
          body: SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Spacer(),
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: DesignTokens.accent1,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusXLarge,
                        ),
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 40,
                        color: DesignTokens.brandDark,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing6),
                    // Title
                    Text(
                      'Welcome Back!',
                      style: AppTextStyles.h1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    Text(
                      'Sign in to continue your fitness journey',
                      style: AppTextStyles.body.copyWith(
                        color: DesignTokens.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignTokens.spacing8),
                    // Form fields
                    AppInput(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                    const SizedBox(height: DesignTokens.spacing4),
                    AppPasswordInput(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DesignTokens.spacing3),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/auth/password-reset'),
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.body.copyWith(
                            color: DesignTokens.accent1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing6),
                    // Sign in button
                    AppButton(
                      text: 'Sign In',
                      onPressed: authProvider.isLoading ? null : _handleSignIn,
                      isLoading: authProvider.isLoading,
                    ),
                    const SizedBox(height: DesignTokens.spacing4),
                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacing4,
                          ),
                          child: Text(
                            'or',
                            style: AppTextStyles.caption.copyWith(
                              color: DesignTokens.textMuted,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing4),
                    // Google sign in
                    AppButton(
                      text: 'Continue with Google',
                      onPressed: authProvider.isLoading
                          ? null
                          : _handleGoogleSignIn,
                      variant: AppButtonVariant.secondary,
                      icon: Icons.g_mobiledata,
                    ),
                    const Spacer(),
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.body.copyWith(
                            color: DesignTokens.textMuted,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/auth/signup'),
                          child: Text(
                            'Sign Up',
                            style: AppTextStyles.body.copyWith(
                              color: DesignTokens.accent1,
                              fontWeight: DesignTokens.semiBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacing4),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      final success = await authProvider.signInUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        context.go('/dashboard');
      } else if (mounted && authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }

  void _handleGoogleSignIn() async {
    // For now, show a message that Google sign in is not implemented
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Google sign in not implemented yet. Please use email/password.',
          ),
          backgroundColor: DesignTokens.warning,
        ),
      );
    }
  }
}
