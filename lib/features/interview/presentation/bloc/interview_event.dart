part of 'interview_bloc.dart';

abstract class InterviewEvent {
  const InterviewEvent();
}

class JoinInterview extends InterviewEvent {
  const JoinInterview({
    required this.meetingCode,
    required this.name,
    required this.micEnabled,
    required this.cameraEnabled,
  });

  final String meetingCode;
  final String name;
  final bool micEnabled;
  final bool cameraEnabled;
}

class LeaveInterview extends InterviewEvent {
  const LeaveInterview(this.session);

  final InterviewSession session;
}

class ToggleMute extends InterviewEvent {
  const ToggleMute({required this.session, required this.muted});

  final InterviewSession session;
  final bool muted;
}

class ToggleCamera extends InterviewEvent {
  const ToggleCamera({required this.session, required this.enabled});

  final InterviewSession session;
  final bool enabled;
}

class SwitchCamera extends InterviewEvent {
  const SwitchCamera(this.session);

  final InterviewSession session;
}
