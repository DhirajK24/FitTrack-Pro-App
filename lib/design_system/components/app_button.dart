import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// Primary button component following the design system
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(theme, isDisabled),
    );
  }

  Widget _buildButton(ThemeData theme, bool isDisabled) {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          child: _buildContent(theme),
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          child: _buildContent(theme),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          child: _buildContent(theme),
        );
      case AppButtonVariant.ghost:
        return _buildGhostButton(theme, isDisabled);
    }
  }

  Widget _buildGhostButton(ThemeData theme, bool isDisabled) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(_getRadius()),
        child: Container(
          height: _getHeight(),
          padding: _getPadding(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_getRadius()),
            border: Border.all(
              color: isDisabled
                  ? DesignTokens.border.withOpacity(0.5)
                  : DesignTokens.border,
            ),
          ),
          child: _buildContent(theme),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary
                ? DesignTokens.brandDark
                : DesignTokens.accent1,
          ),
        ),
      );
    }

    final textStyle = _getTextStyle(theme);
    final iconColor = _getIconColor(theme);

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getIconSize(), color: iconColor),
          const SizedBox(width: DesignTokens.spacing2),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return DesignTokens.buttonHeight;
      case AppButtonSize.large:
        return 56;
    }
  }

  double _getRadius() {
    switch (size) {
      case AppButtonSize.small:
        return DesignTokens.radiusSmall;
      case AppButtonSize.medium:
        return DesignTokens.radiusButton;
      case AppButtonSize.large:
        return DesignTokens.radiusLarge;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing4,
          vertical: DesignTokens.spacing2,
        );
      case AppButtonSize.medium:
        return AppSpacing.buttonPadding;
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing8,
          vertical: DesignTokens.spacing4,
        );
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    final baseStyle = AppTextStyles.button.copyWith(fontSize: _getFontSize());

    switch (variant) {
      case AppButtonVariant.primary:
        return baseStyle.copyWith(color: DesignTokens.brandDark);
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return baseStyle.copyWith(color: DesignTokens.textLight);
      case AppButtonVariant.text:
        return baseStyle.copyWith(color: DesignTokens.accent1);
    }
  }

  Color _getIconColor(ThemeData theme) {
    switch (variant) {
      case AppButtonVariant.primary:
        return DesignTokens.brandDark;
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return DesignTokens.textLight;
      case AppButtonVariant.text:
        return DesignTokens.accent1;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return DesignTokens.captionSize;
      case AppButtonSize.medium:
        return DesignTokens.bodySize;
      case AppButtonSize.large:
        return DesignTokens.h4Size;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}

/// Button variants
enum AppButtonVariant { primary, secondary, text, ghost }

/// Button sizes
enum AppButtonSize { small, medium, large }

/// Icon button component
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.variant = AppButtonVariant.ghost,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final AppButtonVariant variant;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(_getRadius()),
        child: Container(
          width: _getSize(),
          height: _getSize(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_getRadius()),
            color: _getBackgroundColor(theme, isDisabled),
            border: variant == AppButtonVariant.secondary
                ? Border.all(
                    color: isDisabled
                        ? DesignTokens.border.withOpacity(0.5)
                        : DesignTokens.border,
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: _getIconSize(),
            color: _getIconColor(theme, isDisabled),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  double _getSize() {
    switch (size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 40;
      case AppButtonSize.large:
        return 48;
    }
  }

  double _getRadius() {
    switch (size) {
      case AppButtonSize.small:
        return DesignTokens.radiusSmall;
      case AppButtonSize.medium:
        return DesignTokens.radiusMedium;
      case AppButtonSize.large:
        return DesignTokens.radiusLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor(ThemeData theme, bool isDisabled) {
    if (isDisabled) return Colors.transparent;

    switch (variant) {
      case AppButtonVariant.primary:
        return DesignTokens.accent1;
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color _getIconColor(ThemeData theme, bool isDisabled) {
    if (isDisabled) return DesignTokens.textMuted;

    switch (variant) {
      case AppButtonVariant.primary:
        return DesignTokens.brandDark;
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return DesignTokens.textLight;
      case AppButtonVariant.text:
        return DesignTokens.accent1;
    }
  }
}
