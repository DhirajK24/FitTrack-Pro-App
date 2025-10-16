import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'design_system/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/water_provider.dart';
import 'providers/sleep_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/enhanced_workout_provider.dart';
import 'providers/enhanced_water_provider.dart';
import 'providers/enhanced_sleep_provider.dart';
import 'providers/enhanced_progress_provider.dart';
import 'repositories/enhanced_workout_repository.dart';
import 'repositories/enhanced_water_repository.dart';
import 'repositories/enhanced_sleep_repository.dart';
import 'services/hive_storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/personal_info_screen.dart';
import 'screens/onboarding/stats_screen.dart';
import 'screens/onboarding/goals_consent_screen.dart';
import 'screens/onboarding/profile_info_screen.dart';
import 'screens/onboarding/goals_screen.dart';
import 'screens/onboarding/permissions_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/password_reset_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/workout/workout_logger_screen.dart';
import 'screens/workout/exercise_library_screen.dart';
import 'screens/nutrition/ai_nutrition_chat_screen.dart';
import 'screens/nutrition/nutrition_coach_overview_screen.dart';
import 'screens/nutrition/nutrition_chat_screen.dart';
import 'screens/wellness/water_tracker_screen.dart';
import 'screens/wellness/sleep_tracker_screen.dart';
import 'screens/analytics/analytics_dashboard_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveStorageService.initialize();

  runApp(const FitTrackApp());
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WaterProvider(null)),
        ChangeNotifierProvider(create: (_) => SleepProvider(null)),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider(null)),
        // Enhanced providers with repositories
        ChangeNotifierProvider(
          create: (_) => EnhancedWorkoutProvider(EnhancedWorkoutRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => EnhancedWaterProvider(EnhancedWaterRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => EnhancedSleepProvider(EnhancedSleepRepository()),
        ),
        ChangeNotifierProxyProvider3<
          EnhancedWorkoutProvider,
          EnhancedWaterProvider,
          EnhancedSleepProvider,
          EnhancedProgressProvider
        >(
          create: (context) => EnhancedProgressProvider(
            workouts: context.read<EnhancedWorkoutProvider>().workouts,
            waterLogs: context.read<EnhancedWaterProvider>().waterLogs,
            sleepLogs: context.read<EnhancedSleepProvider>().sleepLogs,
          ),
          update:
              (
                context,
                workoutProvider,
                waterProvider,
                sleepProvider,
                previous,
              ) {
                return EnhancedProgressProvider(
                  workouts: workoutProvider.workouts,
                  waterLogs: waterProvider.waterLogs,
                  sleepLogs: sleepProvider.sleepLogs,
                );
              },
        ),
      ],
      child: MaterialApp.router(
        title: 'FitTrack Pro',
        theme: AppTheme.darkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding/personal-info',
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: '/onboarding/stats',
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      path: '/onboarding/goals-consent',
      builder: (context, state) => const GoalsConsentScreen(),
    ),
    GoRoute(
      path: '/onboarding/profile',
      builder: (context, state) => const ProfileInfoScreen(),
    ),
    GoRoute(
      path: '/onboarding/goals',
      builder: (context, state) => const GoalsScreen(),
    ),
    GoRoute(
      path: '/onboarding/permissions',
      builder: (context, state) => const PermissionsScreen(),
    ),
    GoRoute(
      path: '/auth/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/auth/password-reset',
      builder: (context, state) => const PasswordResetScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/workout/logger',
      builder: (context, state) => const WorkoutLoggerScreen(),
    ),
    GoRoute(
      path: '/workout/library',
      builder: (context, state) => const ExerciseLibraryScreen(),
    ),
    GoRoute(
      path: '/nutrition/chat',
      builder: (context, state) => const AINutritionChatScreen(),
    ),
    GoRoute(
      path: '/nutrition-coach',
      builder: (context, state) => const NutritionCoachOverviewScreen(),
    ),
    GoRoute(
      path: '/nutrition-coach/chat',
      builder: (context, state) => const NutritionChatScreen(),
    ),
    GoRoute(
      path: '/nutrition-coach/meal-plan',
      builder: (context, state) =>
          const NutritionCoachOverviewScreen(), // TODO: Create meal plan screen
    ),
    GoRoute(
      path: '/wellness/water',
      builder: (context, state) => const WaterTrackerScreen(),
    ),
    GoRoute(
      path: '/wellness/sleep',
      builder: (context, state) => const SleepTrackerScreen(),
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsDashboardScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
