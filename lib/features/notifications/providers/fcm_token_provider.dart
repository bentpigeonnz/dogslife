import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// World-class FCM Token Manager with advanced options, multi-device support, and Riverpod integration!

final fcmTokenManagerProvider = Provider<FCMTokenManager>((ref) {
  return FCMTokenManager(ref);
});

final currentFcmTokenProvider = FutureProvider<String?>((ref) async {
  return await FirebaseMessaging.instance.getToken();
});

final allFcmTokensProvider = StreamProvider<List<FCMTokenInfo>>((ref) async* {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    yield [];
  } else {
    final tokensRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fcmTokens');

    await for (final snap in tokensRef.snapshots()) {
      yield snap.docs.map((d) => FCMTokenInfo.fromFirestore(d)).toList();
    }
  }
});

class FCMTokenManager {
  final Ref ref;
  FCMTokenManager(this.ref);

  Future<void> registerTokenListener() async {
    await saveFcmTokenToFirestore();
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await saveFcmTokenToFirestore(tokenOverride: token);
    });
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String? model;
    String platform = Platform.operatingSystem;
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      model = info.model;
    } else if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      model = info.computerName;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      model = info.name;
    } else if (Platform.isLinux) {
      final info = await deviceInfo.linuxInfo;
      model = info.name;
    } else if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      model = info.computerName;
    }
    final pkg = await PackageInfo.fromPlatform();
    return {
      'platform': platform,
      'model': model,
      'appVersion': pkg.version,
      'buildNumber': pkg.buildNumber,
    };
  }

  Future<void> saveFcmTokenToFirestore({String? tokenOverride}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('No user logged in');
      return;
    }
    final token = tokenOverride ?? await FirebaseMessaging.instance.getToken();
    if (token == null) {
      debugPrint('No FCM token found.');
      return;
    }
    final deviceMeta = await _getDeviceInfo();
    final tokensRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fcmTokens');
    await tokensRef.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      ...deviceMeta,
    });
  }

  Future<void> removeFcmTokenFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    final tokensRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fcmTokens');
    await tokensRef.doc(token).delete();
  }

  /// Remove any token (for bulk removal)
  Future<void> removeToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final tokensRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fcmTokens');
    await tokensRef.doc(token).delete();
  }
}

/// Model for token info, useful for the UI.
class FCMTokenInfo {
  final String token;
  final String? platform;
  final String? model;
  final String? appVersion;
  final String? buildNumber;
  final DateTime? updatedAt;

  FCMTokenInfo({
    required this.token,
    this.platform,
    this.model,
    this.appVersion,
    this.buildNumber,
    this.updatedAt,
  });

  factory FCMTokenInfo.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return FCMTokenInfo(
      token: d['token'],
      platform: d['platform'],
      model: d['model'],
      appVersion: d['appVersion'],
      buildNumber: d['buildNumber'],
      updatedAt: d['updatedAt'] is Timestamp
          ? (d['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}
