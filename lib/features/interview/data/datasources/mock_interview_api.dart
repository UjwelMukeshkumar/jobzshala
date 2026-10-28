import 'dart:math';

import '../../domain/entities/interview_session.dart';

class MockInterviewApi {
  MockInterviewApi({Random? random}) : _random = random ?? Random();

  final Random _random;

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

    return session.copyWith(status: InterviewStatus.ended);
  }

  Future<InterviewSession> toggleMute(InterviewSession session, bool muted) async {
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));
    return session.copyWith(isMuted: muted, status: InterviewStatus.connected);
  }

  Future<InterviewSession> toggleCamera(InterviewSession session, bool enabled) async {
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));
    return session.copyWith(cameraEnabled: enabled, status: InterviewStatus.connected);
  }

  Future<InterviewSession> switchCamera(InterviewSession session) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(250)));
    return session.copyWith(status: InterviewStatus.connected);
  }
}
