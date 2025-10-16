import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// Modal bottom sheet component
class AppModalBottomSheet extends StatelessWidget {
  const AppModalBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.height,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  final Widget child;
  final String? title;
  final double? height;
  final bool isDismissible;
  final bool enableDrag;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: DesignTokens.spacing3),
            decoration: BoxDecoration(
              color: DesignTokens.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          if (title != null) ...[
            const SizedBox(height: DesignTokens.spacing4),
            Padding(
              padding: AppSpacing.screenPaddingHorizontal,
              child: Text(
                title!,
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing4),
          ],
          // Content
          Flexible(child: child),
        ],
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModalBottomSheet(
        title: title,
        height: height,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        child: child,
      ),
    );
  }
}

/// Confirmation dialog component
class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DesignTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXLarge),
      ),
      title: Text(title, style: AppTextStyles.h3),
      content: Text(message, style: AppTextStyles.body),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }
}

/// Loading dialog component
class AppLoadingDialog extends StatelessWidget {
  const AppLoadingDialog({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DesignTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXLarge),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(DesignTokens.accent1),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    String message = 'Loading...',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppLoadingDialog(message: message),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Toast notification component
class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.type = AppToastType.info,
    this.action,
    this.onActionPressed,
  });

  final String message;
  final AppToastType type;
  final String? action;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        boxShadow: AppShadows.medium,
      ),
      child: Row(
        children: [
          Icon(_getIcon(), color: _getIconColor(), size: 20),
          const SizedBox(width: DesignTokens.spacing3),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: _getTextColor()),
            ),
          ),
          if (action != null && onActionPressed != null) ...[
            const SizedBox(width: DesignTokens.spacing3),
            TextButton(
              onPressed: onActionPressed,
              child: Text(
                action!,
                style: AppTextStyles.caption.copyWith(
                  color: _getTextColor(),
                  fontWeight: DesignTokens.semiBold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case AppToastType.success:
        return DesignTokens.success;
      case AppToastType.error:
        return DesignTokens.error;
      case AppToastType.warning:
        return DesignTokens.warning;
      case AppToastType.info:
        return DesignTokens.info;
    }
  }

  Color _getIconColor() {
    return DesignTokens.textLight;
  }

  Color _getTextColor() {
    return DesignTokens.textLight;
  }

  IconData _getIcon() {
    switch (type) {
      case AppToastType.success:
        return Icons.check_circle;
      case AppToastType.error:
        return Icons.error;
      case AppToastType.warning:
        return Icons.warning;
      case AppToastType.info:
        return Icons.info;
    }
  }

  static void show({
    required BuildContext context,
    required String message,
    AppToastType type = AppToastType.info,
    String? action,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + DesignTokens.spacing4,
        left: DesignTokens.spacing4,
        right: DesignTokens.spacing4,
        child: Material(
          color: Colors.transparent,
          child: AppToast(
            message: message,
            type: type,
            action: action,
            onActionPressed: () {
              overlayEntry.remove();
              onActionPressed?.call();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

/// Toast types
enum AppToastType { success, error, warning, info }

/// Chip component
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.isSelected = false,
    this.variant = AppChipVariant.outlined,
  });

  final String label;
  final VoidCallback? onDeleted;
  final bool isSelected;
  final AppChipVariant variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing3,
        vertical: DesignTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: variant == AppChipVariant.outlined
            ? Border.all(color: _getBorderColor())
            : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: _getTextColor(),
              fontWeight: DesignTokens.medium,
            ),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: DesignTokens.spacing1),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(Icons.close, size: 16, color: _getTextColor()),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return DesignTokens.accent1;
    }

    switch (variant) {
      case AppChipVariant.filled:
        return DesignTokens.surface;
      case AppChipVariant.outlined:
        return Colors.transparent;
    }
  }

  Color _getBorderColor() {
    if (isSelected) {
      return DesignTokens.accent1;
    }
    return DesignTokens.border;
  }

  Color _getTextColor() {
    if (isSelected) {
      return DesignTokens.brandDark;
    }
    return DesignTokens.textLight;
  }
}

/// Chip variants
enum AppChipVariant { filled, outlined }
