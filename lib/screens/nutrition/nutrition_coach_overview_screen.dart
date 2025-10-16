import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_navigation.dart';

class NutritionCoachOverviewScreen extends StatefulWidget {
  const NutritionCoachOverviewScreen({super.key});

  @override
  State<NutritionCoachOverviewScreen> createState() =>
      _NutritionCoachOverviewScreenState();
}

class _NutritionCoachOverviewScreenState
    extends State<NutritionCoachOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'AI Nutrition Coach',
        onBackPressed: () => context.go('/dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () => context.go('/nutrition-coach/chat'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              _buildHeader(),
              const SizedBox(height: DesignTokens.spacing6),
              // Summary cards
              _buildSummaryCards(),
              const SizedBox(height: DesignTokens.spacing6),
              // Featured meal plan
              _buildFeaturedMealPlan(),
              const SizedBox(height: DesignTokens.spacing6),
              // Quick action buttons
              _buildQuickActions(),
              const SizedBox(height: DesignTokens.spacing4),
              // Microcopy
              _buildMicrocopy(),
              const SizedBox(height: DesignTokens.spacing6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
      ),
      child: Row(
        children: [
          // Bot avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: DesignTokens.accent2,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text(
                'FT-COACH',
                style: TextStyle(
                  color: DesignTokens.brandDark,
                  fontSize: 12,
                  fontWeight: DesignTokens.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing4),
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Nutrition Coach',
                  style: AppTextStyles.h3.copyWith(
                    color: DesignTokens.textLight,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing1),
                Text(
                  'Personalized meal plans, local recipes, macro targets',
                  style: AppTextStyles.body.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        // Today's Targets
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Targets",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: DesignTokens.textLight,
                  fontWeight: DesignTokens.semiBold,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              _buildTargetItem('Calories', '2200', 'kcal'),
              _buildTargetItem('Protein', '140', 'g'),
              _buildTargetItem('Carbs', '240', 'g'),
              _buildTargetItem('Fats', '60', 'g'),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacing3),
        // Recent Plan
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Plan',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: DesignTokens.textLight,
                  fontWeight: DesignTokens.semiBold,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: DesignTokens.accent1,
                    size: 20,
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  Expanded(
                    child: Text(
                      '3-day Maharashtrian meal plan',
                      style: AppTextStyles.body.copyWith(
                        color: DesignTokens.textLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacing2),
              Text(
                'Last generated: 2 days ago',
                style: AppTextStyles.caption.copyWith(
                  color: DesignTokens.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacing3),
        // Quick Actions
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: DesignTokens.textLight,
                  fontWeight: DesignTokens.semiBold,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing3),
              _buildQuickActionItem('Generate meal plan', Icons.auto_awesome),
              _buildQuickActionItem('Scan groceries', Icons.qr_code_scanner),
              _buildQuickActionItem('Save favorites', Icons.favorite_outline),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTargetItem(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
          ),
          Text(
            '$value $unit',
            style: AppTextStyles.body.copyWith(
              color: DesignTokens.textLight,
              fontWeight: DesignTokens.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
      child: Row(
        children: [
          Icon(icon, color: DesignTokens.accent1, size: 20),
          const SizedBox(width: DesignTokens.spacing2),
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: DesignTokens.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMealPlan() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: DesignTokens.accent1, size: 20),
              const SizedBox(width: DesignTokens.spacing2),
              Text(
                'Featured Meal Plan',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: DesignTokens.textLight,
                  fontWeight: DesignTokens.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing3),
          Text(
            'Balanced Day — 2200 kcal',
            style: AppTextStyles.h4.copyWith(color: DesignTokens.textLight),
          ),
          const SizedBox(height: DesignTokens.spacing3),
          _buildMealPreview('Breakfast', 'Poha + curd', 'P:18g C:60g F:12g'),
          _buildMealPreview(
            'Lunch',
            'Jowar bhaat + sabzi + dal',
            'P:35g C:120g F:20g',
          ),
          _buildMealPreview(
            'Dinner',
            'Grilled fish + salad',
            'P:45g C:45g F:10g',
          ),
          const SizedBox(height: DesignTokens.spacing4),
          AppButton(
            text: 'View details',
            onPressed: () => context.go('/nutrition-coach/meal-plan'),
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildMealPreview(String meal, String description, String macros) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              meal,
              style: AppTextStyles.caption.copyWith(
                color: DesignTokens.textMuted,
                fontWeight: DesignTokens.medium,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    color: DesignTokens.textLight,
                  ),
                ),
                Text(
                  macros,
                  style: AppTextStyles.caption.copyWith(
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Generate Plan',
            onPressed: () => _handleGeneratePlan(),
            icon: Icons.auto_awesome,
            size: AppButtonSize.large,
          ),
        ),
        const SizedBox(width: DesignTokens.spacing3),
        Expanded(
          child: AppButton(
            text: 'Ask Coach',
            onPressed: () => context.go('/nutrition-coach/chat'),
            variant: AppButtonVariant.secondary,
            icon: Icons.chat,
            size: AppButtonSize.large,
          ),
        ),
      ],
    );
  }

  Widget _buildMicrocopy() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing3),
      decoration: BoxDecoration(
        color: DesignTokens.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      child: Text(
        'All suggestions are AI-generated. Edit before saving. Nutrition advice is informational; consult a pro for medical conditions.',
        style: AppTextStyles.caption.copyWith(
          color: DesignTokens.textMuted,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _handleGeneratePlan() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: DesignTokens.accent1),
      ),
    );

    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      // Navigate to generated plan
      context.go('/nutrition-coach/meal-plan');
    }
  }
}
