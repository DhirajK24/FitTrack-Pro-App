import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_navigation.dart';
import '../../design_system/components/app_modal.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _waterReminders = true;
  bool _workoutReminders = true;
  bool _sleepReminders = true;
  bool _darkMode = true;
  String _selectedUnit = 'Metric';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Settings',
        onBackPressed: () => context.go('/dashboard'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Profile section
            _buildProfileSection(),
            const SizedBox(height: DesignTokens.spacing6),
            // Notifications section
            _buildNotificationsSection(),
            const SizedBox(height: DesignTokens.spacing6),
            // App preferences section
            _buildAppPreferencesSection(),
            const SizedBox(height: DesignTokens.spacing6),
            // Data & privacy section
            _buildDataPrivacySection(),
            const SizedBox(height: DesignTokens.spacing6),
            // About section
            _buildAboutSection(),
            const SizedBox(height: DesignTokens.spacing8),
            // Sign out button
            _buildSignOutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return AppCard(
      child: Column(
        children: [
          // Profile picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: DesignTokens.accent1,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: const Icon(
              Icons.person,
              color: DesignTokens.brandDark,
              size: 40,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Name and email
          Text('John Doe', style: AppTextStyles.h3),
          Text(
            'john.doe@example.com',
            style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Edit profile button
          AppButton(
            text: 'Edit Profile',
            onPressed: _editProfile,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notifications', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          _buildSwitchTile(
            'Push Notifications',
            'Receive notifications from the app',
            _notificationsEnabled,
            (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            'Water Reminders',
            'Remind me to drink water',
            _waterReminders,
            (value) {
              setState(() {
                _waterReminders = value;
              });
            },
          ),
          _buildSwitchTile(
            'Workout Reminders',
            'Remind me about scheduled workouts',
            _workoutReminders,
            (value) {
              setState(() {
                _workoutReminders = value;
              });
            },
          ),
          _buildSwitchTile(
            'Sleep Reminders',
            'Remind me to log my sleep',
            _sleepReminders,
            (value) {
              setState(() {
                _sleepReminders = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppPreferencesSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('App Preferences', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          _buildSwitchTile(
            'Dark Mode',
            'Use dark theme (always enabled)',
            _darkMode,
            (value) {
              setState(() {
                _darkMode = value;
              });
            },
            enabled: false,
          ),
          _buildListTile(
            'Units',
            _selectedUnit,
            Icons.straighten,
            _selectUnits,
          ),
          _buildListTile(
            'Language',
            _selectedLanguage,
            Icons.language,
            _selectLanguage,
          ),
          _buildListTile(
            'Theme',
            'Dark (Default)',
            Icons.palette,
            _selectTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildDataPrivacySection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Data & Privacy', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          _buildListTile(
            'Export Data',
            'Download your data',
            Icons.download,
            _exportData,
          ),
          _buildListTile(
            'Privacy Policy',
            'View privacy policy',
            Icons.privacy_tip,
            _viewPrivacyPolicy,
          ),
          _buildListTile(
            'Terms of Service',
            'View terms of service',
            Icons.description,
            _viewTermsOfService,
          ),
          _buildListTile(
            'Delete Account',
            'Permanently delete account',
            Icons.delete_forever,
            _deleteAccount,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          _buildListTile('App Version', '1.0.0', Icons.info, null),
          _buildListTile(
            'Rate App',
            'Rate us on the App Store',
            Icons.star,
            _rateApp,
          ),
          _buildListTile(
            'Contact Support',
            'Get help and support',
            Icons.help,
            _contactSupport,
          ),
          _buildListTile(
            'Open Source',
            'View source code',
            Icons.code,
            _viewSourceCode,
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return AppButton(
      text: 'Sign Out',
      onPressed: _signOut,
      variant: AppButtonVariant.secondary,
      icon: Icons.logout,
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    return SwitchListTile(
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(color: DesignTokens.textMuted),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: DesignTokens.accent1,
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? DesignTokens.error : DesignTokens.textMuted,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDestructive ? DesignTokens.error : DesignTokens.textLight,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(color: DesignTokens.textMuted),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: DesignTokens.textMuted,
      ),
      onTap: onTap,
    );
  }

  void _editProfile() {
    // TODO: Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _selectUnits() {
    AppModalBottomSheet.show(
      context: context,
      title: 'Select Units',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('Metric (kg, cm)'),
            value: 'Metric',
            groupValue: _selectedUnit,
            onChanged: (value) {
              setState(() {
                _selectedUnit = value!;
              });
              Navigator.of(context).pop();
            },
            activeColor: DesignTokens.accent1,
          ),
          RadioListTile<String>(
            title: const Text('Imperial (lbs, ft)'),
            value: 'Imperial',
            groupValue: _selectedUnit,
            onChanged: (value) {
              setState(() {
                _selectedUnit = value!;
              });
              Navigator.of(context).pop();
            },
            activeColor: DesignTokens.accent1,
          ),
        ],
      ),
    );
  }

  void _selectLanguage() {
    AppModalBottomSheet.show(
      context: context,
      title: 'Select Language',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'English',
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              Navigator.of(context).pop();
            },
            activeColor: DesignTokens.accent1,
          ),
          RadioListTile<String>(
            title: const Text('Spanish'),
            value: 'Spanish',
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              Navigator.of(context).pop();
            },
            activeColor: DesignTokens.accent1,
          ),
        ],
      ),
    );
  }

  void _selectTheme() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dark mode is the only theme available'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _exportData() {
    AppConfirmationDialog.show(
      context: context,
      title: 'Export Data',
      message:
          'This will download all your fitness data as a JSON file. Continue?',
      confirmText: 'Export',
      cancelText: 'Cancel',
      onConfirm: () {
        // TODO: Implement data export
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data export started'),
            backgroundColor: DesignTokens.success,
          ),
        );
      },
    );
  }

  void _viewPrivacyPolicy() {
    // TODO: Open privacy policy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy policy coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _viewTermsOfService() {
    // TODO: Open terms of service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of service coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _deleteAccount() {
    AppConfirmationDialog.show(
      context: context,
      title: 'Delete Account',
      message:
          'This action cannot be undone. All your data will be permanently deleted.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
      onConfirm: () {
        // TODO: Implement account deletion
        context.go('/auth/signin');
      },
    );
  }

  void _rateApp() {
    // TODO: Open app store rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your support!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _contactSupport() {
    // TODO: Open support contact
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support contact coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _viewSourceCode() {
    // TODO: Open source code repository
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Source code coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _signOut() {
    AppConfirmationDialog.show(
      context: context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
      cancelText: 'Cancel',
      onConfirm: () {
        // TODO: Implement sign out
        context.go('/auth/signin');
      },
    );
  }
}
