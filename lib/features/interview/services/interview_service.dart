import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_amazon_chime/flutter_amazon_chime.dart';

import '../domain/entities/interview_session.dart';

class InterviewService {
  InterviewService._internal({Random? random})
      : _random = random ?? Random();

  factory InterviewService() => _instance;

  static final InterviewService _instance = InterviewService._internal();

  final Random _random;
  final StreamController<Map<String, dynamic>> _eventsController =
      StreamController<Map<String, dynamic>>.broadcast();

  StreamSubscription<bool>? _qualitySubscription;
  bool _nativeMeetingStarted = false;
  bool _isCameraEnabled = true;

  Stream<Map<String, dynamic>> get events => _eventsController.stream;

  Future<InterviewSession> joinMeeting({
    required String meetingCode,
    required String name,
    bool micEnabled = true,
    bool cameraEnabled = true,
  }) async {
    await Future.delayed(
      Duration(milliseconds: 900 + _random.nextInt(700)),
    );

    if (_random.nextInt(5) == 0) {
      throw Exception('Unable to join meeting right now. Please try again.');
    }

    _isCameraEnabled = cameraEnabled;

    if (_supportsNativeChime) {
      await AmazonChime.instance.requestAudioPermissions();
      if (cameraEnabled) {
        await AmazonChime.instance.requestVideoPermissions();
      }

      _listenToConnectionQuality();
      _nativeMeetingStarted = false;
    }

    _emit(
      'sessionStarted',
      <String, dynamic>{
        'meetingCode': meetingCode,
        'name': name,
        'micEnabled': micEnabled,
        'cameraEnabled': cameraEnabled,
      },
    );

    return InterviewSession(
      meetingId: 'meeting_${DateTime.now().millisecondsSinceEpoch}',
      meetingCode: meetingCode,
      attendeeName: name,
      isMuted: !micEnabled,
      cameraEnabled: cameraEnabled,
      participantCount: 2,
      status: InterviewStatus.connected,
    );
  }

  Future<InterviewSession> leaveMeeting(InterviewSession session) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(300)));

    if (_supportsNativeChime && _nativeMeetingStarted) {
      await AmazonChime.instance.stopMeeting();
    }

    _nativeMeetingStarted = false;
    await _qualitySubscription?.cancel();
    _qualitySubscription = null;
    _emit('sessionStopped', <String, dynamic>{'reason': 'user_left'});

    return session.copyWith(status: InterviewStatus.ended);
  }

  Future<InterviewSession> toggleMute(InterviewSession session, bool muted) async {
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    if (_supportsNativeChime && _nativeMeetingStarted) {
      if (muted) {
        await AmazonChime.instance.mute();
      } else {
        await AmazonChime.instance.unmute();
      }
    }

    _emit('muteStateChanged', <String, dynamic>{'muted': muted});
    return session.copyWith(isMuted: muted, status: InterviewStatus.connected);
  }

  Future<InterviewSession> toggleCamera(InterviewSession session, bool enabled) async {
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));
    _isCameraEnabled = enabled;

    if (_supportsNativeChime && _nativeMeetingStarted) {
      if (enabled) {
        await AmazonChime.instance.startLocalVideo();
      } else {
        await AmazonChime.instance.stopLocalVideo();
      }
    }

    _emit('videoTileAdded', <String, dynamic>{'cameraEnabled': enabled});
    return session.copyWith(cameraEnabled: enabled, status: InterviewStatus.connected);
  }

  Future<InterviewSession> switchCamera(InterviewSession session) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(250)));

    if (_supportsNativeChime && _nativeMeetingStarted && _isCameraEnabled) {
      await AmazonChime.instance.switchCamera();
    }
    _emit('cameraSwitched', <String, dynamic>{'facing': 'front'});
    return session.copyWith(status: InterviewStatus.connected);
  }

  void _listenToConnectionQuality() {
    _qualitySubscription?.cancel();
    _qualitySubscription = AmazonChime.instance.onConnectionQualityChanged.listen(
      (bool isPoor) {
        _emit(isPoor ? 'connectionPoor' : 'connectionRecovered', <String, dynamic>{});
      },
    );
  }

  bool get _supportsNativeChime {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  void _emit(String event, Map<String, dynamic> payload) {
    if (_eventsController.isClosed) {
      return;
    }
    _eventsController.add(<String, dynamic>{
      'event': event,
      'payload': payload,
    });
  }
}
