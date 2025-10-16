import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_navigation.dart';
import '../../design_system/components/app_card.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final List<PermissionItem> _permissions = [
    PermissionItem(
      id: 'notifications',
      title: 'Push Notifications',
      description: 'Get reminders for workouts, water intake, and sleep goals',
      icon: Icons.notifications,
      isRequired: false,
      isGranted: false,
    ),
    PermissionItem(
      id: 'health_data',
      title: 'Health Data Access',
      description:
          'Sync with Apple Health or Google Fit for automatic tracking',
      icon: Icons.health_and_safety,
      isRequired: false,
      isGranted: false,
    ),
    PermissionItem(
      id: 'location',
      title: 'Location Services',
      description: 'Track outdoor workouts and provide location-based features',
      icon: Icons.location_on,
      isRequired: false,
      isGranted: false,
    ),
    PermissionItem(
      id: 'camera',
      title: 'Camera Access',
      description: 'Take progress photos and scan nutrition labels',
      icon: Icons.camera_alt,
      isRequired: false,
      isGranted: false,
    ),
    PermissionItem(
      id: 'storage',
      title: 'Storage Access',
      description: 'Save workout videos and backup your data',
      icon: Icons.storage,
      isRequired: false,
      isGranted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Permissions',
        onBackPressed: () => context.go('/onboarding/goals'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              // Progress indicator
              AppStepper(currentStep: 3, totalSteps: 4),
              const SizedBox(height: DesignTokens.spacing8),
              // Title
              Text(
                'Enable Permissions',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacing2),
              Text(
                'Grant permissions to unlock all features and personalize your experience',
                style: AppTextStyles.body.copyWith(
                  color: DesignTokens.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacing8),
              // Permissions list
              Expanded(
                child: ListView.builder(
                  itemCount: _permissions.length,
                  itemBuilder: (context, index) {
                    final permission = _permissions[index];
                    return _buildPermissionCard(permission);
                  },
                ),
              ),
              const SizedBox(height: DesignTokens.spacing4),
              // Action buttons
              Column(
                children: [
                  AppButton(
                    text: 'Allow All Permissions',
                    onPressed: _requestAllPermissions,
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(height: DesignTokens.spacing3),
                  AppButton(
                    text: 'Skip for Now',
                    onPressed: _handleSkip,
                    variant: AppButtonVariant.secondary,
                  ),
                  const SizedBox(height: DesignTokens.spacing2),
                  Text(
                    'You can enable these later in Settings',
                    style: AppTextStyles.caption.copyWith(
                      color: DesignTokens.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(PermissionItem permission) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing4),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: permission.isGranted
                  ? DesignTokens.accent1.withOpacity(0.2)
                  : DesignTokens.surface,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: Icon(
              permission.icon,
              color: permission.isGranted
                  ? DesignTokens.accent1
                  : DesignTokens.textMuted,
              size: 24,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing4),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(permission.title, style: AppTextStyles.bodyMedium),
                    if (permission.isRequired) ...[
                      const SizedBox(width: DesignTokens.spacing1),
                      Text(
                        '*',
                        style: AppTextStyles.caption.copyWith(
                          color: DesignTokens.error,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: DesignTokens.spacing1),
                Text(
                  permission.description,
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Status
          if (permission.isGranted)
            const Icon(
              Icons.check_circle,
              color: DesignTokens.accent1,
              size: 20,
            )
          else
            AppIconButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () => _requestPermission(permission),
              size: AppButtonSize.small,
            ),
        ],
      ),
    );
  }

  void _requestPermission(PermissionItem permission) async {
    // TODO: Implement actual permission request
    setState(() {
      permission.isGranted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${permission.title} permission granted'),
        backgroundColor: DesignTokens.success,
      ),
    );
  }

  void _requestAllPermissions() async {
    // TODO: Implement batch permission request
    setState(() {
      for (var permission in _permissions) {
        permission.isGranted = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All permissions granted'),
        backgroundColor: DesignTokens.success,
      ),
    );
  }

  void _handleSkip() {
    // TODO: Save permission preferences
    context.go('/auth/signup');
  }
}

class PermissionItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool isRequired;
  bool isGranted;

  PermissionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isRequired,
    required this.isGranted,
  });
}
