import '../../domain/entities/interview_session.dart';
import '../../domain/repositories/interview_repository.dart';
import '../datasources/mock_interview_api.dart';
import '../../services/chime_bridge.dart';

class InterviewRepositoryImpl implements InterviewRepository {
  InterviewRepositoryImpl({MockInterviewApi? api}) : _api = api ?? MockInterviewApi();

  final MockInterviewApi _api;

  InterviewSession? _currentSession;

  @override
  Future<InterviewSession> joinMeeting({
    required String meetingCode,
    required String name,
    bool micEnabled = true,
    bool cameraEnabled = true,
  }) async {
    final session = await _api.joinMeeting(
      meetingCode: meetingCode,
      name: name,
      micEnabled: micEnabled,
      cameraEnabled: cameraEnabled,
    );

    _currentSession = session;

    await ChimeBridge.joinMeeting(
      meetingCode: meetingCode,
      name: name,
      micEnabled: micEnabled,
      cameraEnabled: cameraEnabled,
    );

    return session;
  }

  @override
  Future<InterviewSession> leaveMeeting(InterviewSession session) async {
    final endedSession = await _api.leaveMeeting(session);
    _currentSession = endedSession;
    await ChimeBridge.leaveMeeting();
    return endedSession;
  }

  @override
  Future<InterviewSession> toggleMute(InterviewSession session, bool muted) async {
    final updated = await _api.toggleMute(session, muted);
    _currentSession = updated;
    await ChimeBridge.toggleMute(muted: muted);
    return updated;
  }

  @override
  Future<InterviewSession> toggleCamera(InterviewSession session, bool enabled) async {
    final updated = await _api.toggleCamera(session, enabled);
    _currentSession = updated;
    await ChimeBridge.toggleCamera(enabled: enabled);
    return updated;
  }

  @override
  Future<InterviewSession> switchCamera(InterviewSession session) async {
    final updated = await _api.switchCamera(session);
    _currentSession = updated;
    await ChimeBridge.switchCamera();
    return updated;
  }

  InterviewSession? get currentSession => _currentSession;
}
