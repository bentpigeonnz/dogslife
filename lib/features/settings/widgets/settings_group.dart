// lib/features/settings/widgets/settings_group.dart

import 'package:flutter/material.dart';

/// World-class settings group/section widget.
/// - Add to any settings screen to group related options.
/// - Fully reusable and styled for Material/Fluent/iOS UIs.
/// - You can add a trailing action (e.g., edit, info, badge) if needed.

class SettingsGroup extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? trailing;
  final bool visible; // Use for RBAC/feature flags

  const SettingsGroup({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
    this.trailing,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (trailing != null) ...[
                  const Spacer(),
                  trailing!,
                ]
              ],
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
