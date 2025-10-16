import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_navigation.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<FitnessGoal> _goals = [
    FitnessGoal(
      id: 'weight_loss',
      title: 'Weight Loss',
      description: 'Burn fat',
      icon: Icons.trending_down,
      isSelected: false,
    ),
    FitnessGoal(
      id: 'muscle_gain',
      title: 'Muscle Gain',
      description: 'Build strength',
      icon: Icons.fitness_center,
      isSelected: false,
    ),
    FitnessGoal(
      id: 'endurance',
      title: 'Endurance',
      description: 'Improve fitness',
      icon: Icons.directions_run,
      isSelected: false,
    ),
    FitnessGoal(
      id: 'flexibility',
      title: 'Flexibility',
      description: 'Mobility & recovery',
      icon: Icons.accessibility_new,
      isSelected: false,
    ),
    FitnessGoal(
      id: 'general_fitness',
      title: 'General Fitness',
      description: 'Health & wellness',
      icon: Icons.health_and_safety,
      isSelected: false,
    ),
    FitnessGoal(
      id: 'sport_specific',
      title: 'Sport Specific',
      description: 'Train for sports',
      icon: Icons.sports,
      isSelected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Fitness Goals',
        onBackPressed: () => context.go('/onboarding/profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Progress indicator
              AppStepper(currentStep: 2, totalSteps: 4),
              const SizedBox(height: DesignTokens.spacing8),
              // Title
              Text(
                'What are your fitness goals?',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacing3),
              Text(
                'Select all that apply - you can change these later',
                style: AppTextStyles.body.copyWith(
                  color: DesignTokens.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacing6),
              // Goals grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  return _buildGoalCard(goal);
                },
              ),
              const SizedBox(height: DesignTokens.spacing4),
              // Continue button
              AppButton(text: 'Continue', onPressed: _handleContinue),
              const SizedBox(height: DesignTokens.spacing4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(FitnessGoal goal) {
    return GestureDetector(
      onTap: () => _toggleGoal(goal),
      child: Container(
        decoration: BoxDecoration(
          color: goal.isSelected
              ? DesignTokens.accent1.withOpacity(0.2)
              : DesignTokens.surface,
          borderRadius: BorderRadius.circular(14),
          border: goal.isSelected
              ? Border.all(color: DesignTokens.accent1, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: goal.isSelected
                      ? DesignTokens.accent1
                      : DesignTokens.accent1.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.radiusMedium,
                  ),
                ),
                child: Icon(
                  goal.icon,
                  color: goal.isSelected
                      ? DesignTokens.brandDark
                      : DesignTokens.accent1,
                  size: 20,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing2),
              // Title
              Flexible(
                child: Text(
                  goal.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: goal.isSelected
                        ? DesignTokens.accent1
                        : DesignTokens.textLight,
                    fontSize: 14,
                    fontWeight: DesignTokens.semiBold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing1),
              // Description
              Flexible(
                child: Text(
                  goal.description,
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.textMuted,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Checkmark (only show if selected and there's space)
              if (goal.isSelected) ...[
                const SizedBox(height: DesignTokens.spacing1),
                const Icon(
                  Icons.check_circle,
                  color: DesignTokens.accent1,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _toggleGoal(FitnessGoal goal) {
    setState(() {
      goal.isSelected = !goal.isSelected;
    });
  }

  void _handleContinue() {
    final selectedGoals = _goals.where((goal) => goal.isSelected).toList();
    if (selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one fitness goal'),
          backgroundColor: DesignTokens.error,
        ),
      );
      return;
    }

    // TODO: Save selected goals
    context.go('/onboarding/permissions');
  }
}

class FitnessGoal {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool isSelected;

  FitnessGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
  });
}
