import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_navigation.dart';
import '../../design_system/components/app_modal.dart';
import '../../providers/app_provider.dart';
import '../../models/workout_model.dart';

class WorkoutLoggerScreen extends StatefulWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  State<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends State<WorkoutLoggerScreen>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _progressController;

  bool _isWorkoutActive = false;
  bool _isResting = false;
  int _restTimeRemaining = 0;
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;

  final List<Exercise> _exercises = [
    Exercise(
      name: 'Push-ups',
      sets: 3,
      reps: 15,
      weight: 0,
      restTime: 60,
      completedSets: 0,
    ),
    Exercise(
      name: 'Squats',
      sets: 3,
      reps: 20,
      weight: 0,
      restTime: 60,
      completedSets: 0,
    ),
    Exercise(
      name: 'Plank',
      sets: 3,
      reps: 30,
      weight: 0,
      restTime: 45,
      completedSets: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Workout Logger',
        onBackPressed: () => context.go('/dashboard'),
        actions: [
          if (_isWorkoutActive)
            TextButton(
              onPressed: _finishWorkout,
              child: Text(
                'Finish',
                style: AppTextStyles.body.copyWith(color: DesignTokens.error),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          // Rest timer (if resting)
          if (_isResting) _buildRestTimer(),
          // Exercise content
          Expanded(
            child: _isWorkoutActive
                ? _buildActiveWorkout()
                : _buildWorkoutSetup(),
          ),
          // Bottom actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final totalSets = _exercises.fold(
      0,
      (sum, exercise) => sum + exercise.sets,
    );
    final completedSets = _exercises.fold(
      0,
      (sum, exercise) => sum + exercise.completedSets,
    );
    final progress = totalSets > 0 ? completedSets / totalSets : 0.0;

    return Container(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: AppTextStyles.bodyMedium),
              Text(
                '$completedSets / $totalSets sets',
                style: AppTextStyles.caption.copyWith(
                  color: DesignTokens.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing2),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: DesignTokens.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(
              DesignTokens.accent1,
            ),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildRestTimer() {
    return Container(
      padding: AppSpacing.screenPadding,
      child: AppCard(
        backgroundColor: DesignTokens.accent1.withOpacity(0.1),
        border: Border.all(color: DesignTokens.accent1.withOpacity(0.3)),
        child: Column(
          children: [
            Text('Rest Time', style: AppTextStyles.h4),
            const SizedBox(height: DesignTokens.spacing2),
            Text(
              '${_restTimeRemaining}s',
              style: AppTextStyles.h1.copyWith(
                fontSize: 48,
                color: DesignTokens.accent1,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                  text: 'Skip Rest',
                  onPressed: _skipRest,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                ),
                AppButton(
                  text: 'Add 30s',
                  onPressed: _addRestTime,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSetup() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ready to start your workout?', style: AppTextStyles.h2),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            'Full Body Strength • 45 min • 5 exercises',
            style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
          ),
          const SizedBox(height: DesignTokens.spacing6),
          // Exercise list
          Expanded(
            child: ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ExerciseCard(
                  name: exercise.name,
                  category: 'Bodyweight',
                  imageUrl:
                      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop',
                  sets: exercise.sets,
                  reps: exercise.reps,
                  weight: exercise.weight,
                  onTap: () => _editExercise(exercise),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveWorkout() {
    if (_currentExerciseIndex >= _exercises.length) {
      return _buildWorkoutComplete();
    }

    final exercise = _exercises[_currentExerciseIndex];
    final isLastSet = _currentSetIndex >= exercise.sets - 1;
    final isLastExercise = _currentExerciseIndex >= _exercises.length - 1;

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          // Current exercise info
          AppCard(
            child: Column(
              children: [
                Text(exercise.name, style: AppTextStyles.h2),
                const SizedBox(height: DesignTokens.spacing2),
                Text(
                  'Set ${_currentSetIndex + 1} of ${exercise.sets}',
                  style: AppTextStyles.body.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSetInfo('Reps', '${exercise.reps}'),
                    _buildSetInfo('Weight', '${exercise.weight}kg'),
                    _buildSetInfo('Rest', '${exercise.restTime}s'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.spacing6),
          // Set completion buttons
          Column(
            children: [
              AppButton(
                text: 'Complete Set',
                onPressed: _completeSet,
                size: AppButtonSize.large,
              ),
              const SizedBox(height: DesignTokens.spacing3),
              if (!isLastSet)
                AppButton(
                  text: 'Skip Set',
                  onPressed: _skipSet,
                  variant: AppButtonVariant.secondary,
                )
              else if (!isLastExercise)
                AppButton(
                  text: 'Next Exercise',
                  onPressed: _nextExercise,
                  variant: AppButtonVariant.secondary,
                )
              else
                AppButton(
                  text: 'Finish Workout',
                  onPressed: _finishWorkout,
                  variant: AppButtonVariant.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(color: DesignTokens.accent1),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: DesignTokens.textMuted),
        ),
      ],
    );
  }

  Widget _buildWorkoutComplete() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: DesignTokens.accent1,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: const Icon(
              Icons.check,
              size: 60,
              color: DesignTokens.brandDark,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing6),
          Text(
            'Workout Complete!',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            'Great job! You\'ve completed all exercises.',
            style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing8),
          AppButton(
            text: 'View Summary',
            onPressed: _showWorkoutSummary,
            size: AppButtonSize.large,
          ),
          const SizedBox(height: DesignTokens.spacing3),
          AppButton(
            text: 'Back to Dashboard',
            onPressed: () => context.go('/dashboard'),
            variant: AppButtonVariant.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    if (!_isWorkoutActive) {
      return Container(
        padding: AppSpacing.screenPadding,
        child: AppButton(
          text: 'Start Workout',
          onPressed: _startWorkout,
          size: AppButtonSize.large,
        ),
      );
    }

    return Container(
      padding: AppSpacing.screenPadding,
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'Add Exercise',
              onPressed: _addExercise,
              variant: AppButtonVariant.secondary,
              icon: Icons.add,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing4),
          Expanded(
            child: AppButton(
              text: 'Pause',
              onPressed: _pauseWorkout,
              variant: AppButtonVariant.secondary,
              icon: Icons.pause,
            ),
          ),
        ],
      ),
    );
  }

  void _startWorkout() async {
    try {
      final appProvider = context.read<AppProvider>();

      // Convert local Exercise objects to ExerciseModel objects
      final exerciseModels = _exercises.map((exercise) {
        final sets = List.generate(exercise.sets, (index) {
          return SetModel(
            id: '${exercise.name}_set_${index + 1}',
            reps: exercise.reps,
            weight: exercise.weight,
            completed: false,
            notes: null,
          );
        });

        return ExerciseModel(
          id: '${exercise.name}_${DateTime.now().millisecondsSinceEpoch}',
          name: exercise.name,
          sets: sets,
          restTime: Duration(seconds: exercise.restTime),
        );
      }).toList();

      // Create draft workout
      final workout = WorkoutModel(
        id: 'workout_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Custom Workout',
        description:
            'Workout started on ${DateTime.now().toString().split(' ')[0]}',
        exercises: exerciseModels,
        createdAt: DateTime.now(),
        status: WorkoutStatus.inProgress,
      );

      // Save draft workout
      await appProvider.workoutRepository.save(workout);

      setState(() {
        _isWorkoutActive = true;
        _currentExerciseIndex = 0;
        _currentSetIndex = 0;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting workout: $e'),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }

  void _completeSet() {
    setState(() {
      _exercises[_currentExerciseIndex].completedSets++;
      _currentSetIndex++;
    });

    if (_currentSetIndex >= _exercises[_currentExerciseIndex].sets) {
      _nextExercise();
    } else {
      _startRest();
    }
  }

  void _skipSet() {
    setState(() {
      _currentSetIndex++;
    });

    if (_currentSetIndex >= _exercises[_currentExerciseIndex].sets) {
      _nextExercise();
    } else {
      _startRest();
    }
  }

  void _nextExercise() {
    setState(() {
      _currentExerciseIndex++;
      _currentSetIndex = 0;
    });
  }

  void _startRest() {
    setState(() {
      _isResting = true;
      _restTimeRemaining = _exercises[_currentExerciseIndex].restTime;
    });

    _timerController.repeat();
    _timerController.addListener(_updateRestTimer);
  }

  void _updateRestTimer() {
    if (_restTimeRemaining > 0) {
      setState(() {
        _restTimeRemaining--;
      });
    } else {
      _skipRest();
    }
  }

  void _skipRest() {
    _timerController.stop();
    _timerController.removeListener(_updateRestTimer);
    setState(() {
      _isResting = false;
    });
  }

  void _addRestTime() {
    setState(() {
      _restTimeRemaining += 30;
    });
  }

  void _pauseWorkout() {
    // TODO: Implement pause functionality
  }

  void _addExercise() {
    // TODO: Navigate to exercise library
    context.go('/workout/library');
  }

  void _editExercise(Exercise exercise) {
    // TODO: Implement exercise editing
  }

  void _finishWorkout() async {
    try {
      final appProvider = context.read<AppProvider>();

      // Convert local Exercise objects to ExerciseModel objects
      final exerciseModels = _exercises.map((exercise) {
        final sets = List.generate(exercise.sets, (index) {
          return SetModel(
            id: '${exercise.name}_set_${index + 1}',
            reps: exercise.reps,
            weight: exercise.weight,
            completed: index < exercise.completedSets,
            notes: null,
          );
        });

        return ExerciseModel(
          id: '${exercise.name}_${DateTime.now().millisecondsSinceEpoch}',
          name: exercise.name,
          sets: sets,
          restTime: Duration(seconds: exercise.restTime),
        );
      }).toList();

      // Create workout model
      final workout = WorkoutModel(
        id: 'workout_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Custom Workout',
        description:
            'Workout completed on ${DateTime.now().toString().split(' ')[0]}',
        exercises: exerciseModels,
        totalDuration: Duration(
          minutes: 30,
        ), // This could be calculated from actual time
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
        status: WorkoutStatus.completed,
      );

      // Save workout to repository
      await appProvider.workoutRepository.save(workout);

      setState(() {
        _isWorkoutActive = false;
        _isResting = false;
      });

      if (mounted) {
        _viewWorkoutSummary(workout);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving workout: $e'),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }

  void _showWorkoutSummary() {
    // Create a simple summary for the button callback
    AppModalBottomSheet.show(
      context: context,
      title: 'Workout Summary',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout completed successfully!',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text('Exercises: ${_exercises.length}', style: AppTextStyles.body),
          const SizedBox(height: 8),
          Text(
            'Total Sets: ${_exercises.fold(0, (sum, exercise) => sum + exercise.completedSets)}',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Done',
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/dashboard');
            },
          ),
        ],
      ),
    );
  }

  void _viewWorkoutSummary(WorkoutModel workout) {
    AppModalBottomSheet.show(
      context: context,
      title: 'Workout Summary',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Great job! Your workout has been saved.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text('Workout: ${workout.name}', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            'Exercises: ${workout.exercises.length}',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 8),
          Text(
            'Duration: ${workout.totalDuration?.inMinutes ?? 0} minutes',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 8),
          Text(
            'Completed: ${workout.completedAt?.toString().split(' ')[0] ?? 'Unknown'}',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'View Details',
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Navigate to workout details
                  },
                  variant: AppButtonVariant.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/dashboard');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final int restTime;
  int completedSets;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restTime,
    required this.completedSets,
  });
}
