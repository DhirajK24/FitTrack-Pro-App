import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../design_tokens.dart';

/// Bottom navigation bar component
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppBottomNavigationItem>? items;

  static const List<AppBottomNavigationItem> defaultItems = [
    AppBottomNavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    AppBottomNavigationItem(
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center,
      label: 'Workout',
    ),
    AppBottomNavigationItem(
      icon: Icons.local_fire_department_outlined,
      activeIcon: Icons.local_fire_department,
      label: 'Coach',
    ),
    AppBottomNavigationItem(
      icon: Icons.bookmark_outline,
      activeIcon: Icons.bookmark,
      label: 'Library',
    ),
    AppBottomNavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationItems = items ?? defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: AppShadows.medium,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        selectedFontSize: DesignTokens.captionSize,
        unselectedFontSize: DesignTokens.captionSize,
        items: navigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: _buildIcon(item, false),
                activeIcon: _buildIcon(item, true),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildIcon(AppBottomNavigationItem item, bool isActive) {
    if (item.svgIcon != null && item.activeSvgIcon != null) {
      return SvgPicture.asset(
        isActive ? item.activeSvgIcon! : item.svgIcon!,
        width: 24,
        height: 24,
      );
    } else {
      return Icon(
        isActive ? item.activeIcon! : item.icon!,
        size: 24,
        color: isActive ? DesignTokens.accent1 : DesignTokens.textMuted,
      );
    }
  }
}

/// Bottom navigation item data
class AppBottomNavigationItem {
  const AppBottomNavigationItem({
    this.icon,
    this.activeIcon,
    this.svgIcon,
    this.activeSvgIcon,
    required this.label,
  }) : assert(
         (icon != null && activeIcon != null) ||
             (svgIcon != null && activeSvgIcon != null),
         'Either icon/activeIcon or svgIcon/activeSvgIcon must be provided',
       );

  final IconData? icon;
  final IconData? activeIcon;
  final String? svgIcon;
  final String? activeSvgIcon;
  final String label;
}

/// App bar component
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.automaticallyImplyLeading = true,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: title != null ? Text(title!) : null,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      systemOverlayStyle: theme.appBarTheme.systemOverlayStyle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom app bar with back button and title
class AppAppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBarWithBack({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.centerTitle = true,
  });

  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppAppBar(
      title: title,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Floating action button component
class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.child,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size = AppFloatingActionButtonSize.regular,
  });

  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? child;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final AppFloatingActionButtonSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget fab = FloatingActionButton(
      onPressed: onPressed,
      backgroundColor:
          backgroundColor ?? theme.floatingActionButtonTheme.backgroundColor,
      foregroundColor:
          foregroundColor ?? theme.floatingActionButtonTheme.foregroundColor,
      elevation: theme.floatingActionButtonTheme.elevation,
      shape: theme.floatingActionButtonTheme.shape,
      child: child ?? (icon != null ? Icon(icon) : null),
    );

    if (tooltip != null) {
      fab = Tooltip(message: tooltip!, child: fab);
    }

    return fab;
  }
}

/// Floating action button sizes
enum AppFloatingActionButtonSize { small, regular, large }

/// Tab bar component
class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
  });

  final List<Widget> tabs;
  final TabController? controller;
  final bool isScrollable;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final double indicatorWeight;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      controller: controller,
      isScrollable: isScrollable,
      labelColor: labelColor ?? DesignTokens.accent1,
      unselectedLabelColor: unselectedLabelColor ?? DesignTokens.textMuted,
      indicatorColor: indicatorColor ?? DesignTokens.accent1,
      indicatorWeight: indicatorWeight,
      labelStyle: AppTextStyles.bodyMedium,
      unselectedLabelStyle: AppTextStyles.body,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Stepper component for onboarding
class AppStepper extends StatelessWidget {
  const AppStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onStepTapped,
  });

  final int currentStep;
  final int totalSteps;
  final ValueChanged<int>? onStepTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return GestureDetector(
          onTap: onStepTapped != null ? () => onStepTapped!(index) : null,
          child: Container(
            margin: EdgeInsets.only(
              right: index < totalSteps - 1 ? DesignTokens.spacing2 : 0,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive || isCompleted
                        ? DesignTokens.accent1
                        : DesignTokens.surface,
                    border: Border.all(
                      color: isActive || isCompleted
                          ? DesignTokens.accent1
                          : DesignTokens.border,
                    ),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusFull,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            color: DesignTokens.brandDark,
                            size: 16,
                          )
                        : Text(
                            '${index + 1}',
                            style: AppTextStyles.caption.copyWith(
                              color: isActive
                                  ? DesignTokens.brandDark
                                  : DesignTokens.textMuted,
                              fontWeight: DesignTokens.semiBold,
                            ),
                          ),
                  ),
                ),
                if (index < totalSteps - 1)
                  Container(
                    width: 24,
                    height: 2,
                    margin: const EdgeInsets.only(left: DesignTokens.spacing2),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? DesignTokens.accent1
                          : DesignTokens.border,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Breadcrumb navigation component
class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({
    super.key,
    required this.items,
    this.separator = '>',
    this.onItemTapped,
  });

  final List<AppBreadcrumbItem> items;
  final String separator;
  final ValueChanged<int>? onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == items.length - 1;

        return Row(
          children: [
            GestureDetector(
              onTap: onItemTapped != null && !isLast
                  ? () => onItemTapped!(index)
                  : null,
              child: Text(
                item.label,
                style: AppTextStyles.caption.copyWith(
                  color: isLast ? DesignTokens.textLight : DesignTokens.accent1,
                  fontWeight: isLast
                      ? DesignTokens.medium
                      : DesignTokens.regular,
                ),
              ),
            ),
            if (!isLast) ...[
              const SizedBox(width: DesignTokens.spacing2),
              Text(
                separator,
                style: AppTextStyles.caption.copyWith(
                  color: DesignTokens.textMuted,
                ),
              ),
              const SizedBox(width: DesignTokens.spacing2),
            ],
          ],
        );
      }).toList(),
    );
  }
}

/// Breadcrumb item data
class AppBreadcrumbItem {
  const AppBreadcrumbItem({required this.label, this.route});

  final String label;
  final String? route;
}
