import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_navigation.dart';
import '../../design_system/components/app_modal.dart';
import '../../providers/sleep_provider.dart';
import '../../models/wellness_model.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Sleep Tracker',
        onBackPressed: () => context.go('/dashboard'),
      ),
      body: Consumer<SleepProvider>(
        builder: (context, sleepProvider, child) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                // Sleep summary
                _buildSleepSummary(sleepProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Log sleep button
                _buildLogSleepButton(sleepProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Sleep quality selector
                _buildSleepQualitySelector(sleepProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Recent sleep logs
                _buildRecentSleepLogs(sleepProvider),
                const SizedBox(height: DesignTokens.spacing6),
                // Sleep trends chart
                _buildSleepTrendsChart(sleepProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSleepSummary(SleepProvider sleepProvider) {
    final lastNight = sleepProvider.lastNightSleep;
    final avgSleep = sleepProvider.averageSleep;

    return AppCard(
      child: Column(
        children: [
          Text('Last Night\'s Sleep', style: AppTextStyles.h3),
          const SizedBox(height: DesignTokens.spacing4),
          if (lastNight != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSleepStat(
                  'Duration',
                  '${lastNight.duration.inHours}h ${lastNight.duration.inMinutes % 60}m',
                  Icons.bedtime,
                ),
                _buildSleepStat(
                  'Quality',
                  lastNight.quality.name.toUpperCase(),
                  _getQualityIcon(lastNight.quality),
                ),
                _buildSleepStat(
                  'Bedtime',
                  _formatTime(lastNight.bedtime),
                  Icons.nightlight,
                ),
              ],
            ),
          ] else ...[
            Text(
              'No sleep data recorded',
              style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
            ),
          ],
          const SizedBox(height: DesignTokens.spacing4),
          // Average sleep
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing3),
            decoration: BoxDecoration(
              color: DesignTokens.accent1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up, color: DesignTokens.accent1, size: 20),
                const SizedBox(width: DesignTokens.spacing2),
                Text(
                  'Average: ${avgSleep.inHours}h ${avgSleep.inMinutes % 60}m',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: DesignTokens.accent1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: DesignTokens.accent1, size: 24),
        const SizedBox(height: DesignTokens.spacing1),
        Text(value, style: AppTextStyles.h4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: DesignTokens.textMuted),
        ),
      ],
    );
  }

  Widget _buildLogSleepButton(SleepProvider sleepProvider) {
    return AppButton(
      text: 'Log Sleep',
      onPressed: _showLogSleepModal,
      size: AppButtonSize.large,
      icon: Icons.add,
    );
  }

  Widget _buildSleepQualitySelector(SleepProvider sleepProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sleep Quality', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          Row(
            children: SleepQuality.values.map((quality) {
              final isSelected = sleepProvider.selectedQuality == quality;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    sleepProvider.setSelectedQuality(quality);
                  },
                  child: Container(
                    height: 80, // Fixed height for consistency
                    margin: const EdgeInsets.only(right: DesignTokens.spacing2),
                    padding: const EdgeInsets.all(DesignTokens.spacing2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? DesignTokens.accent1.withOpacity(0.2)
                          : DesignTokens.surface,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMedium,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? DesignTokens.accent1
                            : DesignTokens.border,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getQualityIcon(quality),
                          color: isSelected
                              ? DesignTokens.accent1
                              : DesignTokens.textMuted,
                          size:
                              20, // Slightly smaller icon for better proportion
                        ),
                        const SizedBox(height: DesignTokens.spacing1),
                        Text(
                          quality.name.toUpperCase(),
                          style: AppTextStyles.caption.copyWith(
                            color: isSelected
                                ? DesignTokens.accent1
                                : DesignTokens.textMuted,
                            fontWeight: isSelected
                                ? DesignTokens.semiBold
                                : DesignTokens.regular,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSleepLogs(SleepProvider sleepProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Sleep Logs', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          if (sleepProvider.recentLogs.isEmpty)
            Text(
              'No sleep logs yet. Start tracking your sleep!',
              style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
            )
          else
            Column(
              children: sleepProvider.recentLogs.take(5).map((log) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
                  child: Row(
                    children: [
                      Icon(
                        _getQualityIcon(log.quality),
                        color: _getQualityColor(log.quality),
                        size: 20,
                      ),
                      const SizedBox(width: DesignTokens.spacing3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${log.duration.inHours}h ${log.duration.inMinutes % 60}m',
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              '${_formatDate(log.bedtime)} • ${log.quality.name.toUpperCase()}',
                              style: AppTextStyles.caption.copyWith(
                                color: DesignTokens.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(log.bedtime),
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

  Widget _buildSleepTrendsChart(SleepProvider sleepProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          Text('Sleep Trends (7 days)', style: AppTextStyles.h4),
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
                  final sleepLog = sleepProvider.weeklyData[day];
                  final hours = sleepLog?.inHours.toDouble() ?? 0.0;
                  final height = (hours / 10) * 80; // Max 80px height

                  return Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${hours.toInt()}h',
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
                            color: sleepLog != null
                                ? DesignTokens.accent1
                                : DesignTokens.surface,
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

  void _showLogSleepModal() {
    AppModalBottomSheet.show(
      context: context,
      title: 'Log Sleep',
      child: LogSleepModal(
        onLogSleep: (bedtime, wakeTime, quality) {
          final sleepProvider = context.read<SleepProvider>();
          sleepProvider.logSleep(bedtime, wakeTime, quality);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  IconData _getQualityIcon(SleepQuality quality) {
    switch (quality) {
      case SleepQuality.excellent:
        return Icons.sentiment_very_satisfied;
      case SleepQuality.good:
        return Icons.sentiment_satisfied;
      case SleepQuality.fair:
        return Icons.sentiment_neutral;
      case SleepQuality.poor:
        return Icons.sentiment_dissatisfied;
    }
  }

  Color _getQualityColor(SleepQuality quality) {
    switch (quality) {
      case SleepQuality.excellent:
        return DesignTokens.success;
      case SleepQuality.good:
        return DesignTokens.accent1;
      case SleepQuality.fair:
        return DesignTokens.warning;
      case SleepQuality.poor:
        return DesignTokens.error;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  String _getDayName(DateTime day) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[day.weekday - 1];
  }
}

class LogSleepModal extends StatefulWidget {
  const LogSleepModal({super.key, required this.onLogSleep});

  final Function(DateTime bedtime, DateTime wakeTime, SleepQuality quality)
  onLogSleep;

  @override
  State<LogSleepModal> createState() => _LogSleepModalState();
}

class _LogSleepModalState extends State<LogSleepModal> {
  DateTime _bedtime = DateTime.now().subtract(const Duration(hours: 8));
  DateTime _wakeTime = DateTime.now();
  SleepQuality _quality = SleepQuality.good;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bedtime
        ListTile(
          leading: const Icon(Icons.bedtime),
          title: const Text('Bedtime'),
          trailing: Text(_formatTime(_bedtime)),
          onTap: _selectBedtime,
        ),
        // Wake time
        ListTile(
          leading: const Icon(Icons.wb_sunny),
          title: const Text('Wake Time'),
          trailing: Text(_formatTime(_wakeTime)),
          onTap: _selectWakeTime,
        ),
        // Sleep quality
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Sleep Quality'),
          trailing: DropdownButton<SleepQuality>(
            value: _quality,
            onChanged: (value) {
              setState(() {
                _quality = value!;
              });
            },
            items: SleepQuality.values.map((quality) {
              return DropdownMenuItem(
                value: quality,
                child: Text(quality.name.toUpperCase()),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: DesignTokens.spacing4),
        // Log button
        AppButton(
          text: 'Log Sleep',
          onPressed: () {
            widget.onLogSleep(_bedtime, _wakeTime, _quality);
          },
        ),
      ],
    );
  }

  void _selectBedtime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_bedtime),
    );
    if (time != null) {
      setState(() {
        _bedtime = DateTime(
          _bedtime.year,
          _bedtime.month,
          _bedtime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _selectWakeTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_wakeTime),
    );
    if (time != null) {
      setState(() {
        _wakeTime = DateTime(
          _wakeTime.year,
          _wakeTime.month,
          _wakeTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}
