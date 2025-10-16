import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_navigation.dart';
import '../../providers/app_provider.dart';

class GoalsConsentScreen extends StatefulWidget {
  const GoalsConsentScreen({super.key});

  @override
  State<GoalsConsentScreen> createState() => _GoalsConsentScreenState();
}

class _GoalsConsentScreenState extends State<GoalsConsentScreen> {
  final List<String> _primaryGoals = [
    'Muscle Gain',
    'Run 5k',
    'Bench 80kg',
    'Lose 5kg',
  ];

  String? _selectedGoal;
  bool _enableReminders = true;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Step 4 of 4 – Goals & Consent',
        onBackPressed: () => context.go('/onboarding/stats'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              AppStepper(currentStep: 3, totalSteps: 4),
              const SizedBox(height: 24),
              // Title
              Text('Step 4 of 4 – Goals & Consent', style: AppTextStyles.h2),
              const SizedBox(height: 24),
              // Primary Goal section
              Text(
                'Primary Goal',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: DesignTokens.textLight,
                ),
              ),
              const SizedBox(height: 12),
              _buildGoalSelector(),
              const SizedBox(height: 24),
              // Add custom goal button
              Center(
                child: TextButton(
                  onPressed: _addCustomGoal,
                  child: Text(
                    '+ Add custom goal',
                    style: AppTextStyles.body.copyWith(
                      color: DesignTokens.accent1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Reminders toggle
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Enable reminders for workout, water, sleep',
                      style: AppTextStyles.body.copyWith(
                        color: DesignTokens.textLight,
                      ),
                    ),
                  ),
                  Switch(
                    value: _enableReminders,
                    onChanged: (value) {
                      setState(() {
                        _enableReminders = value;
                      });
                    },
                    activeColor: DesignTokens.accent1,
                    activeTrackColor: DesignTokens.accent1.withOpacity(0.3),
                    inactiveThumbColor: DesignTokens.textMuted,
                    inactiveTrackColor: DesignTokens.surface,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Terms and privacy checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                      });
                    },
                    activeColor: DesignTokens.accent1,
                    checkColor: DesignTokens.brandDark,
                    side: BorderSide(color: DesignTokens.border),
                  ),
                  Expanded(
                    child: Text(
                      'I agree to Terms & Privacy',
                      style: AppTextStyles.body.copyWith(
                        color: DesignTokens.textLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Create account button
              AppButton(
                text: 'Create Account & Continue',
                onPressed: _agreeToTerms ? _handleCreateAccount : null,
                size: AppButtonSize.large,
              ),
              const SizedBox(height: 16),
              // Skip button
              Center(
                child: TextButton(
                  onPressed: () => context.go('/dashboard'),
                  child: Text(
                    'Skip for now',
                    style: AppTextStyles.body.copyWith(
                      color: DesignTokens.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _primaryGoals.map((goal) {
        final isSelected = _selectedGoal == goal;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedGoal = isSelected ? null : goal;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? DesignTokens.accent1 : DesignTokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? DesignTokens.accent1 : DesignTokens.border,
              ),
            ),
            child: Text(
              goal,
              style: AppTextStyles.body.copyWith(
                color: isSelected
                    ? DesignTokens.brandDark
                    : DesignTokens.textLight,
                fontWeight: isSelected
                    ? DesignTokens.semiBold
                    : DesignTokens.regular,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _addCustomGoal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.surface,
        title: Text(
          'Add Custom Goal',
          style: AppTextStyles.h4.copyWith(color: DesignTokens.textLight),
        ),
        content: TextField(
          style: AppTextStyles.body.copyWith(color: DesignTokens.textLight),
          decoration: InputDecoration(
            hintText: 'Enter your custom goal',
            hintStyle: AppTextStyles.body.copyWith(
              color: DesignTokens.textMuted,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: DesignTokens.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: DesignTokens.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: DesignTokens.accent1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Add custom goal
              Navigator.of(context).pop();
            },
            child: Text(
              'Add',
              style: AppTextStyles.body.copyWith(color: DesignTokens.accent1),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCreateAccount() async {
    try {
      final appProvider = context.read<AppProvider>();

      // Get current user and add goals
      final currentUser = appProvider.currentUser;
      if (currentUser == null) {
        throw Exception(
          'No user found. Please restart the onboarding process.',
        );
      }

      // Add selected goal to goals list
      final goals = <String>[];
      if (_selectedGoal != null) {
        goals.add(_selectedGoal!);
      }

      // Update user profile with goals and complete onboarding
      final updatedUser = currentUser.copyWith(
        goals: goals,
        // Add any other final user data here
      );

      await appProvider.completeOnboarding(updatedUser);

      if (mounted) {
        context.go('/dashboard');
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
