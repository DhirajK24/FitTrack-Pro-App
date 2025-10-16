import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../providers/app_provider.dart';
import '../../models/user_model.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 64, left: 24, right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: DesignTokens.accent1,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: DesignTokens.brandDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        'Welcome to FitTrack Pro',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 32,
                          fontWeight: DesignTokens.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      Text(
                        'Personalized plans, workout tracking & AI nutrition.',
                        style: AppTextStyles.body.copyWith(
                          color: DesignTokens.textMuted,
                          fontSize: 16,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Hero illustration
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: DesignTokens.accent1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.directions_run,
                          size: 100,
                          color: DesignTokens.accent1,
                        ),
                      ),
                      const Spacer(),
                      // Buttons
                      AppButton(
                        text: 'Continue with Google',
                        onPressed: _handleGoogleSignIn,
                        size: AppButtonSize.large,
                        icon: Icons.g_mobiledata,
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        text: 'Continue with Email',
                        onPressed: _handleContinueWithEmail,
                        size: AppButtonSize.large,
                        variant: AppButtonVariant.secondary,
                      ),
                      const SizedBox(height: 16),
                      // Sign in link
                      TextButton(
                        onPressed: () => context.go('/auth/signin'),
                        child: Text(
                          'Sign In',
                          style: AppTextStyles.body.copyWith(
                            color: DesignTokens.accent1,
                            fontSize: 16,
                            fontWeight: DesignTokens.medium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Terms text
                      Text(
                        'By continuing you agree Terms & Privacy',
                        style: AppTextStyles.caption.copyWith(
                          color: DesignTokens.textMuted,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      final appProvider = context.read<AppProvider>();

      // Create a temporary user for Google sign in
      final user = UserModel(
        id: 'google_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@gmail.com', // This would come from Google sign in
        displayName: 'Google User',
        photoUrl: null,
        dateOfBirth: null,
        gender: null,
        weight: null,
        height: null,
        fitnessLevel: null,
        goals: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await appProvider.login(user);

      if (mounted) {
        context.go('/onboarding/personal-info');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in with Google: $e'),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }

  void _handleContinueWithEmail() async {
    try {
      final appProvider = context.read<AppProvider>();

      // Create a temporary user for email sign up
      final user = UserModel(
        id: 'email_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@example.com', // This would come from email input
        displayName: null, // Will be filled in personal info screen
        photoUrl: null,
        dateOfBirth: null,
        gender: null,
        weight: null,
        height: null,
        fitnessLevel: null,
        goals: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await appProvider.login(user);

      if (mounted) {
        context.go('/onboarding/personal-info');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating account: $e'),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }
}
