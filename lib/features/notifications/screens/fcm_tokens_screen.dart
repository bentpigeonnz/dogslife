import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/fcm_token_provider.dart';

class FcmTokensScreen extends ConsumerWidget {
  const FcmTokensScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTokens = ref.watch(allFcmTokensProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("FCM Device Tokens")),
      body: allTokens.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (tokens) => tokens.isEmpty
            ? const Center(child: Text("No tokens found."))
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tokens.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final t = tokens[i];
            return ListTile(
              title: Text(
                t.token,
                style: const TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                  "${t.platform ?? '-'} | ${t.model ?? '-'} | v${t.appVersion ?? '-'}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: "Copy",
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: t.token),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Token copied to clipboard")));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: "Remove",
                    onPressed: () async {
                      await ref
                          .read(fcmTokenManagerProvider)
                          .removeToken(t.token);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
