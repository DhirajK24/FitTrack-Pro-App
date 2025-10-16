import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_input.dart';
import '../../design_system/components/app_navigation.dart';
import '../../models/enums.dart';
import '../../providers/app_provider.dart';
import '../../models/user_model.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedGender = 'Male';
  String? _profileImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Step 2 of 4 – Personal Info',
        onBackPressed: () => context.go('/onboarding/welcome'),
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
                AppStepper(currentStep: 1, totalSteps: 4),
                const SizedBox(height: 24),
                // Title
                Text('Step 2 of 4 – Personal Info', style: AppTextStyles.h2),
                const SizedBox(height: 24),
                // Full Name input
                AppInput(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Date of Birth input
                AppInput(
                  controller: _dateController,
                  labelText: 'Date of Birth',
                  hintText: 'DD/MM/YYYY',
                  readOnly: true,
                  onTap: _selectDate,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                const SizedBox(height: 16),
                // Gender selection
                Text(
                  'Gender',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: DesignTokens.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGenderSelector(),
                const SizedBox(height: 24),
                // Profile photo upload
                Text(
                  'Add photo',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: DesignTokens.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                _buildPhotoUpload(),
                const SizedBox(height: 32),
                // Button row
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Back',
                        onPressed: () => context.go('/onboarding/welcome'),
                        variant: AppButtonVariant.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'Next: Stats',
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

  Widget _buildGenderSelector() {
    return Row(
      children: ['Male', 'Female', 'Other'].map((gender) {
        final isSelected = _selectedGender == gender;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedGender = gender;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? DesignTokens.accent1.withOpacity(0.2)
                    : DesignTokens.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? DesignTokens.accent1
                      : DesignTokens.border,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? DesignTokens.accent1
                        : DesignTokens.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gender,
                    style: AppTextStyles.body.copyWith(
                      color: isSelected
                          ? DesignTokens.accent1
                          : DesignTokens.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: _selectPhoto,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: DesignTokens.surface,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: DesignTokens.border),
        ),
        child: _profileImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(_profileImagePath!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: DesignTokens.textMuted,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add photo',
                    style: AppTextStyles.caption.copyWith(
                      color: DesignTokens.textMuted,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      _dateController.text =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  void _selectPhoto() {
    // TODO: Implement photo selection
    setState(() {
      _profileImagePath = 'assets/images/placeholder_avatar.png';
    });
  }

  void _handleNext() async {
    if (_formKey.currentState!.validate()) {
      try {
        final appProvider = context.read<AppProvider>();

        // Parse date of birth
        DateTime? dateOfBirth;
        if (_dateController.text.isNotEmpty) {
          final parts = _dateController.text.split('/');
          if (parts.length == 3) {
            dateOfBirth = DateTime(
              int.parse(parts[2]), // year
              int.parse(parts[1]), // month
              int.parse(parts[0]), // day
            );
          }
        }

        // Convert gender string to enum
        Gender? gender;
        switch (_selectedGender) {
          case 'Male':
            gender = Gender.male;
            break;
          case 'Female':
            gender = Gender.female;
            break;
          case 'Other':
            gender = Gender.other;
            break;
        }

        // Update user profile with personal info
        await appProvider.updateUserProfile(
          displayName: _nameController.text.trim(),
          dateOfBirth: dateOfBirth,
          gender: gender,
          photoUrl: _profileImagePath,
        );

        if (mounted) {
          context.go('/onboarding/stats');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving personal info: $e'),
              backgroundColor: DesignTokens.error,
            ),
          );
        }
      }
    }
  }
}
