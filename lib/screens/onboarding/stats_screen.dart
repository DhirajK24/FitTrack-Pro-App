import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_input.dart';
import '../../design_system/components/app_navigation.dart';
import '../../models/enums.dart';
import '../../design_system/components/app_card.dart';
import '../../providers/app_provider.dart';
import '../../models/user_model.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController(text: '72');
  final _heightController = TextEditingController(text: '175');

  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _fitnessLevel = 'Intermediate';
  double _bmi = 23.5;

  @override
  void initState() {
    super.initState();
    _calculateBMI();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Step 3 of 4 – Your Body',
        onBackPressed: () => context.go('/onboarding/personal-info'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                AppStepper(currentStep: 2, totalSteps: 4),
                const SizedBox(height: 24),
                // Title
                Text('Step 3 of 4 – Your Body', style: AppTextStyles.h2),
                const SizedBox(height: 24),
                // Weight input
                AppNumberInput(
                  controller: _weightController,
                  labelText: 'Weight',
                  hintText: 'Enter your weight',
                  suffix: _weightUnit,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Please enter a valid weight';
                    }
                    return null;
                  },
                  onChanged: (value) => _calculateBMI(),
                ),
                const SizedBox(height: 8),
                _buildUnitSelector('weight'),
                const SizedBox(height: 16),
                // Height input
                AppNumberInput(
                  controller: _heightController,
                  labelText: 'Height',
                  hintText: 'Enter your height',
                  suffix: _heightUnit,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height <= 0) {
                      return 'Please enter a valid height';
                    }
                    return null;
                  },
                  onChanged: (value) => _calculateBMI(),
                ),
                const SizedBox(height: 8),
                _buildUnitSelector('height'),
                const SizedBox(height: 24),
                // Fitness level
                Text(
                  'Fitness Level',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: DesignTokens.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFitnessLevelSelector(),
                const SizedBox(height: 24),
                // BMI card
                AppCard(
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: DesignTokens.accent1,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BMI Estimate: ${_bmi.toStringAsFixed(1)} (Healthy)',
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              'Auto-calculated after input',
                              style: AppTextStyles.caption.copyWith(
                                color: DesignTokens.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Button row
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Back',
                        onPressed: () =>
                            context.go('/onboarding/personal-info'),
                        variant: AppButtonVariant.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'Next: Goals',
                        onPressed: _handleNext,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitSelector(String type) {
    final options = type == 'weight' ? ['kg', 'lb'] : ['cm', 'in'];
    final selectedUnit = type == 'weight' ? _weightUnit : _heightUnit;

    return Row(
      children: options.map((unit) {
        final isSelected = selectedUnit == unit;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (type == 'weight') {
                  _weightUnit = unit;
                } else {
                  _heightUnit = unit;
                }
                _calculateBMI();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? DesignTokens.accent1 : DesignTokens.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? DesignTokens.accent1
                      : DesignTokens.border,
                ),
              ),
              child: Text(
                unit,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected
                      ? DesignTokens.brandDark
                      : DesignTokens.textLight,
                  fontWeight: isSelected
                      ? DesignTokens.semiBold
                      : DesignTokens.regular,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFitnessLevelSelector() {
    return Row(
      children: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
        final isSelected = _fitnessLevel == level;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _fitnessLevel = level;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? DesignTokens.accent1 : DesignTokens.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? DesignTokens.accent1
                      : DesignTokens.border,
                ),
              ),
              child: Text(
                level,
                style: AppTextStyles.body.copyWith(
                  color: isSelected
                      ? DesignTokens.brandDark
                      : DesignTokens.textLight,
                  fontWeight: isSelected
                      ? DesignTokens.semiBold
                      : DesignTokens.regular,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;

    if (weight > 0 && height > 0) {
      // Convert to kg and cm if needed
      double weightKg = weight;
      double heightCm = height;

      if (_weightUnit == 'lb') {
        weightKg = weight * 0.453592;
      }
      if (_heightUnit == 'in') {
        heightCm = height * 2.54;
      }

      final heightM = heightCm / 100;
      setState(() {
        _bmi = weightKg / (heightM * heightM);
      });
    }
  }

  void _handleNext() async {
    if (_formKey.currentState!.validate()) {
      try {
        final appProvider = context.read<AppProvider>();

        // Parse weight and height
        final weight = double.tryParse(_weightController.text) ?? 0.0;
        final height = double.tryParse(_heightController.text) ?? 0.0;

        // Convert to kg and cm if needed
        double weightInKg = weight;
        double heightInCm = height;

        if (_weightUnit == 'lb') {
          weightInKg = weight * 0.453592; // Convert lbs to kg
        }
        if (_heightUnit == 'in') {
          heightInCm = height * 2.54; // Convert inches to cm
        }

        // Convert fitness level string to enum
        FitnessLevel? fitnessLevel;
        switch (_fitnessLevel) {
          case 'Beginner':
            fitnessLevel = FitnessLevel.beginner;
            break;
          case 'Intermediate':
            fitnessLevel = FitnessLevel.intermediate;
            break;
          case 'Advanced':
            fitnessLevel = FitnessLevel.advanced;
            break;
        }

        // Update user profile with stats
        await appProvider.updateUserProfile(
          weight: weightInKg,
          height: heightInCm,
          fitnessLevel: fitnessLevel,
        );

        if (mounted) {
          context.go('/onboarding/goals-consent');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving stats: $e'),
              backgroundColor: DesignTokens.error,
            ),
          );
        }
      }
    }
  }
}
