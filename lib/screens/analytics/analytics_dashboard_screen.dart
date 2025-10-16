import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_navigation.dart';
import '../../providers/analytics_provider.dart';
import '../../models/analytics_model.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTimeRange = 7; // 7, 30, 90 days

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBar(
        title: 'Analytics',
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('Last 7 days')),
              const PopupMenuItem(value: 30, child: Text('Last 30 days')),
              const PopupMenuItem(value: 90, child: Text('Last 90 days')),
            ],
          ),
        ],
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, analyticsProvider, child) {
          if (analyticsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: DesignTokens.accent1),
            );
          }

          return RefreshIndicator(
            onRefresh: () => analyticsProvider.refresh(),
            color: DesignTokens.accent1,
            backgroundColor: DesignTokens.surface,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCards(analyticsProvider),
                  const SizedBox(height: 24),
                  _buildProgressCharts(analyticsProvider),
                  const SizedBox(height: 24),
                  _buildAchievementsSection(analyticsProvider),
                  const SizedBox(height: 24),
                  _buildInsightsSection(analyticsProvider),
                  const SizedBox(height: 24),
                  _buildWeeklyReport(analyticsProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(AnalyticsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTextStyles.h2.copyWith(color: DesignTokens.textLight),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Total Points',
                '${provider.totalPoints}',
                Icons.stars,
                DesignTokens.accent1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Achievements',
                '${provider.unlockedAchievements.length}',
                Icons.emoji_events,
                DesignTokens.accent2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Workout Streak',
                '${_calculateStreak(provider)} days',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Insights',
                '${provider.unreadInsights.length}',
                Icons.lightbulb,
                Colors.yellow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignTokens.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              color: DesignTokens.textLight,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCharts(AnalyticsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Trends',
          style: AppTextStyles.h2.copyWith(color: DesignTokens.textLight),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignTokens.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignTokens.border, width: 1),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                _buildWaterChart(provider),
                _buildSleepChart(provider),
                _buildWorkoutChart(provider),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildWaterChart(AnalyticsProvider provider) {
    final data = provider.analyticsData.take(_selectedTimeRange).toList();
    final spots = data.asMap().entries.map((entry) {
      final value = entry.value.waterIntakeMl?.toDouble() ?? 0;
      return FlSpot(entry.key.toDouble(), value / 1000); // Convert to liters
    }).toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.cyan,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: Colors.cyan.withOpacity(0.1),
      ),
    );
  }

  LineChartBarData _buildSleepChart(AnalyticsProvider provider) {
    final data = provider.analyticsData.take(_selectedTimeRange).toList();
    final spots = data.asMap().entries.map((entry) {
      final value = entry.value.sleepDuration?.inHours.toDouble() ?? 0;
      return FlSpot(entry.key.toDouble(), value);
    }).toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.purple,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: Colors.purple.withOpacity(0.1),
      ),
    );
  }

  LineChartBarData _buildWorkoutChart(AnalyticsProvider provider) {
    final data = provider.analyticsData.take(_selectedTimeRange).toList();
    final spots = data.asMap().entries.map((entry) {
      final value = entry.value.completedWorkouts?.toDouble() ?? 0;
      return FlSpot(entry.key.toDouble(), value);
    }).toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.orange,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: Colors.orange.withOpacity(0.1),
      ),
    );
  }

  Widget _buildAchievementsSection(AnalyticsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: AppTextStyles.h2.copyWith(color: DesignTokens.textLight),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full achievements screen
              },
              child: Text(
                'View All',
                style: AppTextStyles.body.copyWith(color: DesignTokens.accent1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.achievements.length,
            itemBuilder: (context, index) {
              final achievement = provider.achievements[index];
              return _buildAchievementCard(achievement);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? achievement.color.withOpacity(0.1)
            : DesignTokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achievement.isUnlocked
              ? achievement.color
              : DesignTokens.border,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(achievement.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            style: AppTextStyles.caption.copyWith(
              color: achievement.isUnlocked
                  ? DesignTokens.textLight
                  : DesignTokens.textMuted,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (achievement.isUnlocked) ...[
            const SizedBox(height: 4),
            Text(
              '${achievement.points} pts',
              style: AppTextStyles.caption.copyWith(
                color: achievement.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightsSection(AnalyticsProvider provider) {
    final insights = provider.insights.take(3).toList();

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights',
          style: AppTextStyles.h2.copyWith(color: DesignTokens.textLight),
        ),
        const SizedBox(height: 16),
        ...insights.map((insight) => _buildInsightCard(insight)),
      ],
    );
  }

  Widget _buildInsightCard(Insight insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: insight.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: insight.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTextStyles.body.copyWith(
                    color: DesignTokens.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: AppTextStyles.body.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (!insight.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: DesignTokens.accent1,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyReport(AnalyticsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Report',
          style: AppTextStyles.h2.copyWith(color: DesignTokens.textLight),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignTokens.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignTokens.border, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReportStat(
                    'Workouts',
                    '${_getWeeklyWorkouts(provider)}',
                  ),
                  _buildReportStat('Water', '${_getWeeklyWater(provider)}L'),
                  _buildReportStat('Sleep', '${_getWeeklySleep(provider)}h'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.generateWeeklyReport(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.accent1,
                  foregroundColor: DesignTokens.brandDark,
                ),
                child: const Text('Generate Report'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h1.copyWith(
            color: DesignTokens.textLight,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: DesignTokens.textMuted),
        ),
      ],
    );
  }

  int _calculateStreak(AnalyticsProvider provider) {
    // Simple streak calculation - count consecutive days with workouts
    int streak = 0;
    final data = provider.analyticsData;

    for (final day in data) {
      if (day.completedWorkouts != null && day.completedWorkouts! > 0) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  int _getWeeklyWorkouts(AnalyticsProvider provider) {
    final weekData = provider.analyticsData.take(7);
    return weekData.fold(0, (sum, day) => sum + (day.completedWorkouts ?? 0));
  }

  double _getWeeklyWater(AnalyticsProvider provider) {
    final weekData = provider.analyticsData.take(7);
    final totalMl = weekData.fold(
      0,
      (sum, day) => sum + (day.waterIntakeMl ?? 0),
    );
    return (totalMl / 1000) / 7; // Average daily in liters
  }

  double _getWeeklySleep(AnalyticsProvider provider) {
    final weekData = provider.analyticsData.take(7);
    final totalHours = weekData.fold(
      0.0,
      (sum, day) => sum + (day.sleepDuration?.inHours ?? 0),
    );
    return totalHours / 7; // Average daily in hours
  }
}
