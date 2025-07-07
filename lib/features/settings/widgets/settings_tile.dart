// lib/features/settings/widgets/settings_tile.dart

import 'package:flutter/material.dart';

/// A powerful, highly flexible settings tile/list item.
/// Supports:
///   - Icon or leading widget
///   - Title and optional subtitle/description
///   - Optional trailing widget (e.g. switch, badge, value, chevron, etc)
///   - Tap/click or long press callbacks
///   - Optional color, enabled/disabled state, visibility (for RBAC)
class SettingsTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool visible;
  final Color? tileColor;
  final EdgeInsetsGeometry? contentPadding;

  const SettingsTile({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.visible = true,
    this.tileColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final effectiveLeading = leading ??
        (icon != null
            ? Icon(icon, color: enabled ? theme.colorScheme.primary : Colors.grey)
            : null);

    return ListTile(
      enabled: enabled,
      leading: effectiveLeading,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: enabled ? null : Colors.grey,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: enabled ? Colors.grey[700] : Colors.grey[400],
        ),
      )
          : null,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      tileColor: tileColor ?? theme.cardColor,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      minLeadingWidth: icon != null || leading != null ? 36 : 0,
      visualDensity: VisualDensity.compact,
    );
  }
}
