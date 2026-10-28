import '../entities/interview_session.dart';

abstract class InterviewRepository {
  Future<InterviewSession> joinMeeting({
    required String meetingCode,
    required String name,
    bool micEnabled,
    bool cameraEnabled,
  });

  Future<InterviewSession> leaveMeeting(InterviewSession session);
  Future<InterviewSession> toggleMute(InterviewSession session, bool muted);
  Future<InterviewSession> toggleCamera(InterviewSession session, bool enabled);
  Future<InterviewSession> switchCamera(InterviewSession session);
}
