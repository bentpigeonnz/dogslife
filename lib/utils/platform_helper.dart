import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

bool get isWebPlatform => kIsWeb;

bool get isMobilePlatform =>
    defaultTargetPlatform == TargetPlatform.android;
