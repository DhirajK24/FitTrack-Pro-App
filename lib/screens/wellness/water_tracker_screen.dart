import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_navigation.dart';
import '../../widgets/water_intake_widget.dart';
import '../../providers/water_provider.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;

  final List<WaterAmount> _waterAmounts = [
    WaterAmount(amountMl: 250, label: 'Glass', icon: Icons.local_drink),
    WaterAmount(amountMl: 500, label: 'Bottle', icon: Icons.water_drop),
    WaterAmount(amountMl: 750, label: 'Large', icon: Icons.water),
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Water Tracker',
        onBackPressed: () => context.go('/dashboard'),
      ),
      body: Consumer<WaterProvider>(
        builder: (context, waterProvider, child) {
          final visualProgress = waterProvider.progressPercentage;
          final actualPercentage = waterProvider.actualPercentage;

          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                // Water bottle visualization
                _buildWaterBottle(
                  waterProvider,
                  visualProgress,
                  actualPercentage,
                ),
                const SizedBox(height: DesignTokens.spacing6),
                // Progress stats
                _buildProgressStats(waterProvider, actualPercentage),
                const SizedBox(height: DesignTokens.spacing6),
                // Quick add buttons
                _buildQuickAddButtons(waterProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Today's log
                _buildTodaysLog(waterProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Weekly chart
                _buildWeeklyChart(waterProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaterBottle(
    WaterProvider waterProvider,
    double visualProgress,
    int actualPercentage,
  ) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Today\'s Hydration', style: AppTextStyles.h3),
              if (waterProvider.isGoalExceeded)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing2,
                    vertical: DesignTokens.spacing1,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.accent2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Goal exceeded',
                    style: AppTextStyles.caption.copyWith(
                      color: DesignTokens.brandDark,
                      fontWeight: DesignTokens.semiBold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Water bottle with wave animation
          WaterIntakeWidget(
            currentMl: waterProvider.currentWaterMl,
            goalMl: waterProvider.goalWaterMl,
            width: 120,
            height: 280,
            onTap: () {
              // Optional: Add tap to add water functionality
            },
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            '${waterProvider.formatVolume(waterProvider.currentWaterMl)} / ${waterProvider.formatVolume(waterProvider.goalWaterMl)}',
            style: AppTextStyles.h4,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStats(WaterProvider waterProvider, int percentage) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: 'Goal Progress',
            value: '$percentage%',
            icon: Icons.flag,
            subtitle: 'of daily goal',
          ),
        ),
        const SizedBox(width: DesignTokens.spacing4),
        Expanded(
          child: StatsCard(
            title: waterProvider.isGoalExceeded ? 'Exceeded' : 'Remaining',
            value: waterProvider.computeRemainingText(),
            icon: waterProvider.isGoalExceeded
                ? Icons.trending_up
                : Icons.timer,
            subtitle: waterProvider.isGoalExceeded
                ? 'goal exceeded'
                : 'to reach goal',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAddButtons(WaterProvider waterProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Add', style: AppTextStyles.h4),
        const SizedBox(height: DesignTokens.spacing4),
        Row(
          children: _waterAmounts.map((waterAmount) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: DesignTokens.spacing2),
                child: _buildWaterAmountButton(waterAmount),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWaterAmountButton(WaterAmount waterAmount) {
    return Consumer<WaterProvider>(
      builder: (context, waterProvider, child) {
        return GestureDetector(
          onTap: () => waterProvider.addWater(waterAmount.amountMl),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            decoration: BoxDecoration(
              color: DesignTokens.surface,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              border: Border.all(color: DesignTokens.border),
            ),
            child: Column(
              children: [
                Icon(waterAmount.icon, color: DesignTokens.accent1, size: 32),
                const SizedBox(height: DesignTokens.spacing2),
                Text(
                  waterProvider.formatVolume(waterAmount.amountMl),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: DesignTokens.accent1,
                  ),
                ),
                Text(
                  waterAmount.label,
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodaysLog(WaterProvider waterProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Today\'s Log', style: AppTextStyles.h4),
              TextButton(
                onPressed: _showAddWaterModal,
                child: Text(
                  'Add Custom',
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.accent1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),
          if (waterProvider.todayLogs.isEmpty)
            Text(
              'No water logged today. Start hydrating!',
              style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
            )
          else
            Column(
              children: waterProvider.todayLogs.map((log) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: DesignTokens.accent1,
                        size: 16,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      Text(
                        waterProvider.formatVolume(log.amountMl),
                        style: AppTextStyles.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(log.timestamp),
                        style: AppTextStyles.caption.copyWith(
                          color: DesignTokens.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(WaterProvider waterProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          Text('Weekly Progress', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 120, maxHeight: 140),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final day = DateTime.now().subtract(
                    Duration(days: 6 - index),
                  );
                  final isToday = day.day == DateTime.now().day;
                  final waterAmountMl = waterProvider.weeklyData[day] ?? 0;
                  final height =
                      (waterAmountMl / waterProvider.goalWaterMl) *
                      80; // Max 80px height

                  return Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          waterProvider.formatVolume(waterAmountMl),
                          style: AppTextStyles.caption.copyWith(
                            color: DesignTokens.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacing1),
                        Container(
                          width: 24,
                          height: height,
                          decoration: BoxDecoration(
                            color: isToday
                                ? DesignTokens.accent1
                                : DesignTokens.accent1.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacing1),
                        Text(
                          _getDayName(day),
                          style: AppTextStyles.caption.copyWith(
                            color: DesignTokens.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddWaterModal() {
    // TODO: Show custom water amount modal
  }

  String _getDayName(DateTime day) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[day.weekday - 1];
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}

class WaterAmount {
  final int amountMl;
  final String label;
  final IconData icon;

  WaterAmount({
    required this.amountMl,
    required this.label,
    required this.icon,
  });
}

class WaterLog {
  final int amountMl;
  final DateTime timestamp;

  WaterLog({required this.amountMl, required this.timestamp});
}
