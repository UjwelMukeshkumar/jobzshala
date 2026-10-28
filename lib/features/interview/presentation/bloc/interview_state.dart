part of 'interview_bloc.dart';

abstract class InterviewState {
  const InterviewState();
}

class InterviewInitial extends InterviewState {}

class InterviewJoining extends InterviewState {}

class InterviewConnected extends InterviewState {
  const InterviewConnected(this.session);

  final InterviewSession session;
}

class InterviewError extends InterviewState {
  const InterviewError(this.message);

  final String message;
}

class InterviewEnded extends InterviewState {
  const InterviewEnded(this.session);

  final InterviewSession session;
}
