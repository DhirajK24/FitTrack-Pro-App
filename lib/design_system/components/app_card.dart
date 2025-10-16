import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// Card component following the design system
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation = AppCardElevation.soft,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.width,
    this.height,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AppCardElevation elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Border? border;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardTheme.color,
        borderRadius:
            borderRadius ?? BorderRadius.circular(DesignTokens.radiusCard),
        border: border,
        boxShadow: _getShadow(),
      ),
      child: Padding(padding: padding ?? AppSpacing.cardPadding, child: child),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              borderRadius ?? BorderRadius.circular(DesignTokens.radiusCard),
          child: card,
        ),
      );
    }

    return card;
  }

  List<BoxShadow> _getShadow() {
    switch (elevation) {
      case AppCardElevation.none:
        return [];
      case AppCardElevation.soft:
        return AppShadows.soft;
      case AppCardElevation.medium:
        return AppShadows.medium;
      case AppCardElevation.strong:
        return AppShadows.strong;
    }
  }
}

/// Card elevation levels
enum AppCardElevation { none, soft, medium, strong }

/// Workout card component
class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.exerciseCount,
    required this.imageUrl,
    required this.onTap,
    this.subtitle,
    this.isCompleted = false,
    this.progress,
  });

  final String title;
  final String duration;
  final int exerciseCount;
  final String imageUrl;
  final VoidCallback onTap;
  final String? subtitle;
  final bool isCompleted;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Progress overlay
                if (progress != null && progress! > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        DesignTokens.accent1,
                      ),
                    ),
                  ),
                // Completed badge
                if (isCompleted)
                  const Positioned(
                    top: DesignTokens.spacing2,
                    right: DesignTokens.spacing2,
                    child: Icon(
                      Icons.check_circle,
                      color: DesignTokens.accent1,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TODAY\'S WORKOUT',
                style: AppTextStyles.caption.copyWith(
                  color: DesignTokens.accent1,
                  fontWeight: DesignTokens.medium,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: DesignTokens.spacing1),
              Text(
                title,
                style: AppTextStyles.h3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: DesignTokens.spacing1),
                Text(
                  subtitle!,
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                ),
              ],
              const SizedBox(height: DesignTokens.spacing4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$duration • $exerciseCount exercises',
                    style: AppTextStyles.caption.copyWith(
                      color: DesignTokens.textMuted,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      isCompleted ? 'Review' : 'Start',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stats card component
class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.trend,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Widget? trend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: DesignTokens.accent1.withOpacity(0.2),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: Icon(icon, color: DesignTokens.accent1, size: 24),
          ),
          const SizedBox(width: DesignTokens.spacing4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                const SizedBox(height: DesignTokens.spacing1),
                Text(
                  value,
                  style: AppTextStyles.h4.copyWith(
                    color: DesignTokens.textLight,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(
                      color: DesignTokens.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trend != null) trend!,
        ],
      ),
    );
  }
}

/// Exercise card component
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.onTap,
    this.isSelected = false,
    this.sets,
    this.reps,
    this.weight,
  });

  final String name;
  final String category;
  final String imageUrl;
  final VoidCallback onTap;
  final bool isSelected;
  final int? sets;
  final int? reps;
  final double? weight;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      border: isSelected
          ? Border.all(color: DesignTokens.accent1, width: 2)
          : null,
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing4),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignTokens.spacing1),
                Text(
                  category,
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                ),
                if (sets != null || reps != null || weight != null) ...[
                  const SizedBox(height: DesignTokens.spacing2),
                  Row(
                    children: [
                      if (sets != null) ...[
                        _buildStatChip('$sets sets'),
                        const SizedBox(width: DesignTokens.spacing2),
                      ],
                      if (reps != null) ...[
                        _buildStatChip('$reps reps'),
                        const SizedBox(width: DesignTokens.spacing2),
                      ],
                      if (weight != null) ...[_buildStatChip('${weight}kg')],
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Selection indicator
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: DesignTokens.accent1,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing2,
        vertical: DesignTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.accent1.withOpacity(0.2),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: DesignTokens.accent1,
          fontWeight: DesignTokens.medium,
        ),
      ),
    );
  }
}

/// Meal card component for AI nutrition chat
class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    this.onTap,
    this.isAIGenerated = false,
  });

  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;
  final VoidCallback? onTap;
  final bool isAIGenerated;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: DesignTokens.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                if (isAIGenerated)
                  Positioned(
                    top: DesignTokens.spacing2,
                    right: DesignTokens.spacing2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing2,
                        vertical: DesignTokens.spacing1,
                      ),
                      decoration: BoxDecoration(
                        color: DesignTokens.accent1,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusSmall,
                        ),
                      ),
                      child: Text(
                        'AI Generated',
                        style: AppTextStyles.caption.copyWith(
                          color: DesignTokens.brandDark,
                          fontWeight: DesignTokens.medium,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Content
          Text(
            name,
            style: AppTextStyles.h4,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignTokens.spacing2),
          // Macros
          Row(
            children: [
              _buildMacroItem('Calories', '$calories'),
              const SizedBox(width: DesignTokens.spacing4),
              _buildMacroItem('Protein', '${protein}g'),
              const SizedBox(width: DesignTokens.spacing4),
              _buildMacroItem('Carbs', '${carbs}g'),
              const SizedBox(width: DesignTokens.spacing4),
              _buildMacroItem('Fat', '${fat}g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(color: DesignTokens.accent1),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: DesignTokens.textMuted),
        ),
      ],
    );
  }
}
