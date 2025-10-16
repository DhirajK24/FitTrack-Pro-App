import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_navigation.dart';
import '../../providers/app_provider.dart';
import '../../providers/water_provider.dart';
import '../../providers/sleep_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBar(
        title: 'FitTrack',
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => context.go('/analytics'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          GestureDetector(
            onTap: () => context.go('/settings'),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: DesignTokens.accent1,
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
              ),
              child: const Icon(
                Icons.person,
                color: DesignTokens.brandDark,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing2),
        ],
      ),
      body: Consumer3<AppProvider, WaterProvider, SleepProvider>(
        builder: (context, appProvider, waterProvider, sleepProvider, child) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                _buildGreeting(appProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Today's Workout Card
                _buildTodaysWorkout(appProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Weekly Activity Chart
                _buildWeeklyActivity(appProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Quick Stats
                _buildQuickStats(waterProvider, sleepProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Motivation Banner
                _buildMotivationBanner(),
                const SizedBox(height: DesignTokens.spacing8),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleBottomNavTap(index);
        },
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: () => context.go('/workout/logger'),
        icon: Icons.add,
        tooltip: 'Start Workout',
      ),
    );
  }

  Widget _buildGreeting(AppProvider appProvider) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    final userName = appProvider.currentUser?.displayName ?? 'there';
    final firstName = userName.split(' ').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $firstName!',
          style: AppTextStyles.h2.copyWith(color: DesignTokens.textMuted),
        ),
        Text('Ready to crush your goals?', style: AppTextStyles.h1),
      ],
    );
  }

  Widget _buildTodaysWorkout(AppProvider appProvider) {
    // For now, show a default workout card
    // TODO: Implement workout tracking to show actual workout data
    return WorkoutCard(
      title: 'Start Your Workout',
      duration: '0 min',
      exerciseCount: 0,
      imageUrl:
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=200&fit=crop',
      onTap: () => context.go('/workout/logger'),
      subtitle: 'Tap to begin your fitness journey',
      progress: 0.0,
    );
  }

  Widget _buildWeeklyActivity(AppProvider appProvider) {
    // For now, show sample data
    // TODO: Implement workout tracking to show actual activity data
    final sampleData = [50, 90, 80, 50, 40, 30, 30];
    final totalCalories = sampleData.fold(0, (sum, calories) => sum + calories);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Activity', style: AppTextStyles.h4),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to analytics
                },
                child: Text(
                  'View All',
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.accent1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            '$totalCalories',
            style: AppTextStyles.h1.copyWith(fontSize: 32),
          ),
          Text(
            'calories burned this week',
            style: AppTextStyles.caption.copyWith(
              color: DesignTokens.textMuted,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(
                          days[value.toInt()],
                          style: AppTextStyles.caption.copyWith(
                            color: DesignTokens.textMuted,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  final calories = sampleData[index];
                  final height = calories.toDouble();

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(toY: height, color: DesignTokens.accent1),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    WaterProvider waterProvider,
    SleepProvider sleepProvider,
  ) {
    final waterFormatted = waterProvider.formatVolume(
      waterProvider.currentWaterMl,
    );
    final waterGoalFormatted = waterProvider.formatVolume(
      waterProvider.goalWaterMl,
    );
    final lastNightSleep = sleepProvider.lastNightSleep;
    final sleepFormatted = lastNightSleep != null
        ? '${lastNightSleep.duration.inHours}h ${lastNightSleep.duration.inMinutes % 60}m'
        : 'No data';

    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: 'Water Intake',
            value: waterFormatted,
            icon: Icons.water_drop,
            subtitle: 'of $waterGoalFormatted goal',
            onTap: () => context.go('/wellness/water'),
          ),
        ),
        const SizedBox(width: DesignTokens.spacing4),
        Expanded(
          child: StatsCard(
            title: 'Sleep',
            value: sleepFormatted,
            icon: Icons.bed,
            subtitle: lastNightSleep != null ? 'last night' : 'no data',
            onTap: () => context.go('/wellness/sleep'),
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationBanner() {
    return AppCard(
      backgroundColor: DesignTokens.accent1.withOpacity(0.1),
      border: Border.all(color: DesignTokens.accent1.withOpacity(0.3)),
      child: Column(
        children: [
          Icon(Icons.psychology, color: DesignTokens.accent1, size: 32),
          const SizedBox(height: DesignTokens.spacing3),
          Text(
            '"The only bad workout is the one that didn\'t happen."',
            style: AppTextStyles.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              color: DesignTokens.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            '- Anonymous',
            style: AppTextStyles.caption.copyWith(
              color: DesignTokens.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        context.go('/workout/logger');
        break;
      case 2:
        context.go('/nutrition-coach');
        break;
      case 3:
        context.go('/workout/library');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
