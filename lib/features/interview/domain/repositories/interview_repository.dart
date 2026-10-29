import '../entities/interview_session.dart';
import '../../services/interview_service.dart';

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

class InterviewRepositoryImpl implements InterviewRepository {
  InterviewRepositoryImpl({InterviewService? interviewService})
      : _interviewService = interviewService ?? InterviewService();

  final InterviewService _interviewService;

  InterviewSession? _currentSession;

  @override
  Future<InterviewSession> joinMeeting({
    required String meetingCode,
    required String name,
    bool micEnabled = true,
    bool cameraEnabled = true,
  }) async {
    final session = await _interviewService.joinMeeting(
      meetingCode: meetingCode,
      name: name,
      micEnabled: micEnabled,
      cameraEnabled: cameraEnabled,
    );

    _currentSession = session;

    return session;
  }

  @override
  Future<InterviewSession> leaveMeeting(InterviewSession session) async {
    final endedSession = await _interviewService.leaveMeeting(session);
    _currentSession = endedSession;
    return endedSession;
  }

  @override
  Future<InterviewSession> toggleMute(InterviewSession session, bool muted) async {
    final updated = await _interviewService.toggleMute(session, muted);
    _currentSession = updated;
    return updated;
  }

  @override
  Future<InterviewSession> toggleCamera(InterviewSession session, bool enabled) async {
    final updated = await _interviewService.toggleCamera(session, enabled);
    _currentSession = updated;
    return updated;
  }

  @override
  Future<InterviewSession> switchCamera(InterviewSession session) async {
    final updated = await _interviewService.switchCamera(session);
    _currentSession = updated;
    return updated;
  }

  InterviewSession? get currentSession => _currentSession;
}
