import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../design_system/design_tokens.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/water_provider.dart';
import '../providers/sleep_provider.dart';
import '../providers/analytics_provider.dart';
import '../providers/enhanced_workout_provider.dart';
import '../providers/enhanced_water_provider.dart';
import '../providers/enhanced_sleep_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    // Delay provider initialization to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  void _navigateToNextScreen() async {
    // Initialize providers
    await _initializeProviders();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _navigateBasedOnAuthState();
      }
    });
  }

  Future<void> _initializeProviders() async {
    final appProvider = context.read<AppProvider>();
    final authProvider = context.read<AuthProvider>();

    await appProvider.initialize();
    await authProvider.initialize();

    if (appProvider.isInitialized && mounted) {
      final waterProvider = context.read<WaterProvider>();
      final sleepProvider = context.read<SleepProvider>();
      final analyticsProvider = context.read<AnalyticsProvider>();
      final enhancedWorkoutProvider = context.read<EnhancedWorkoutProvider>();
      final enhancedWaterProvider = context.read<EnhancedWaterProvider>();
      final enhancedSleepProvider = context.read<EnhancedSleepProvider>();

      // Update repositories
      waterProvider.updateRepository(appProvider.waterRepository);
      sleepProvider.updateRepository(appProvider.sleepRepository);
      analyticsProvider.updateRepositories(
        analyticsRepository: appProvider.analyticsRepository,
        workoutRepository: appProvider.workoutRepository,
        waterRepository: appProvider.waterRepository,
        sleepRepository: appProvider.sleepRepository,
      );

      await Future.wait([
        waterProvider.initialize(),
        sleepProvider.initialize(),
        analyticsProvider.initialize(),
        enhancedWorkoutProvider.initialize(),
        enhancedWaterProvider.initialize(),
        enhancedSleepProvider.initialize(),
      ]);
    }
  }

  void _navigateBasedOnAuthState() {
    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();

    if (authProvider.isSignedIn) {
      if (appProvider.isOnboardingComplete) {
        context.go('/dashboard');
      } else {
        context.go('/onboarding/welcome');
      }
    } else {
      context.go('/auth/signin');
    }
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
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: DesignTokens.accent1,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusXLarge,
                        ),
                        boxShadow: AppShadows.glow,
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 60,
                        color: DesignTokens.brandDark,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing6),
                    // App Name
                    Text(
                      'FitTrack',
                      style: AppTextStyles.h1.copyWith(
                        color: DesignTokens.textLight,
                        fontSize: 36,
                        fontWeight: DesignTokens.extraBold,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing2),
                    // Tagline
                    Text(
                      'Your Personal Fitness Companion',
                      style: AppTextStyles.body.copyWith(
                        color: DesignTokens.textMuted,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing8),
                    // Loading indicator
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DesignTokens.accent1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
