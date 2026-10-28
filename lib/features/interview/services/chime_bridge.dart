import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ChimeBridge {
  static const MethodChannel _methodChannel =
      MethodChannel('jobzshala/interview');
  static const EventChannel _eventChannel =
      EventChannel('jobzshala/interview_events');

  static Stream<Map<String, dynamic>>? _events;

  static Stream<Map<String, dynamic>> get events {
    if (!_supportsNativeBridge) {
      return const Stream<Map<String, dynamic>>.empty();
    }

    _events ??= _eventChannel.receiveBroadcastStream().map(
      (event) => Map<String, dynamic>.from(event as Map<dynamic, dynamic>),
    );
    return _events!;
  }

  static Future<void> joinMeeting({
    required String meetingCode,
    required String name,
    bool micEnabled = true,
    bool cameraEnabled = true,
  }) async {
    if (!_supportsNativeBridge) {
      return;
    }

    await _methodChannel.invokeMethod('join', {
      'meetingCode': meetingCode,
      'name': name,
      'micEnabled': micEnabled,
      'cameraEnabled': cameraEnabled,
    });
  }

  static Future<void> leaveMeeting() async {
    if (!_supportsNativeBridge) {
      return;
    }
    await _methodChannel.invokeMethod('leave');
  }

  static Future<void> toggleMute({required bool muted}) async {
    if (!_supportsNativeBridge) {
      return;
    }
    await _methodChannel.invokeMethod('toggleMute', {'muted': muted});
  }

  static Future<void> toggleCamera({required bool enabled}) async {
    if (!_supportsNativeBridge) {
      return;
    }
    await _methodChannel.invokeMethod('toggleCamera', {'enabled': enabled});
  }

  static Future<void> switchCamera() async {
    if (!_supportsNativeBridge) {
      return;
    }
    await _methodChannel.invokeMethod('switchCamera');
  }

  static bool get _supportsNativeBridge {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }
}
