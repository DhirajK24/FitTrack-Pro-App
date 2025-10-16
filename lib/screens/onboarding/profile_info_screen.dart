import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_input.dart';
import '../../design_system/components/app_navigation.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Profile Setup',
        onBackPressed: () => context.go('/onboarding/welcome'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Progress indicator
                AppStepper(currentStep: 1, totalSteps: 4),
                const SizedBox(height: DesignTokens.spacing8),
                // Title
                Text(
                  'Tell us about yourself',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacing2),
                Text(
                  'This helps us personalize your fitness experience',
                  style: AppTextStyles.body.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacing8),
                // Form fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile picture
                        _buildProfilePicture(),
                        const SizedBox(height: DesignTokens.spacing6),
                        // Name
                        AppInput(
                          controller: _nameController,
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DesignTokens.spacing4),
                        // Age
                        AppNumberInput(
                          controller: _ageController,
                          labelText: 'Age',
                          hintText: '25',
                          suffix: 'years',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 13 || age > 120) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DesignTokens.spacing4),
                        // Gender
                        _buildGenderSelector(),
                        const SizedBox(height: DesignTokens.spacing4),
                        // Height
                        AppNumberInput(
                          controller: _heightController,
                          labelText: 'Height',
                          hintText: '170',
                          suffix: 'cm',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            final height = double.tryParse(value);
                            if (height == null ||
                                height < 100 ||
                                height > 250) {
                              return 'Please enter a valid height';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DesignTokens.spacing4),
                        // Weight
                        AppNumberInput(
                          controller: _weightController,
                          labelText: 'Weight',
                          hintText: '70',
                          suffix: 'kg',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null || weight < 30 || weight > 300) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: DesignTokens.spacing8),
                      ],
                    ),
                  ),
                ),
                // Continue button
                AppButton(text: 'Continue', onPressed: _handleContinue),
                const SizedBox(height: DesignTokens.spacing4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _selectProfilePicture,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: DesignTokens.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(color: DesignTokens.border, width: 2),
        ),
        child: const Icon(
          Icons.person,
          size: 60,
          color: DesignTokens.textMuted,
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: AppTextStyles.label),
        const SizedBox(height: DesignTokens.spacing2),
        Container(
          decoration: BoxDecoration(
            color: DesignTokens.surface,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            border: Border.all(color: DesignTokens.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              isExpanded: true,
              padding: AppSpacing.inputPadding,
              style: AppTextStyles.body,
              dropdownColor: DesignTokens.surface,
              items: _genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _selectProfilePicture() {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture selection coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save profile data
      context.go('/onboarding/goals');
    }
  }
}
