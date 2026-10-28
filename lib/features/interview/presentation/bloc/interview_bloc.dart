import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/interview_session.dart';
import '../../domain/repositories/interview_repository.dart';

part 'interview_event.dart';
part 'interview_state.dart';

class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  InterviewBloc({required InterviewRepository repository})
      : _repository = repository,
        super(InterviewInitial()) {
    on<JoinInterview>(_onJoinInterview);
    on<LeaveInterview>(_onLeaveInterview);
    on<ToggleMute>(_onToggleMute);
    on<ToggleCamera>(_onToggleCamera);
    on<SwitchCamera>(_onSwitchCamera);
  }

  final InterviewRepository _repository;

  Future<void> _onJoinInterview(
    JoinInterview event,
    Emitter<InterviewState> emit,
  ) async {
    emit(InterviewJoining());

    try {
      final session = await _repository.joinMeeting(
        meetingCode: event.meetingCode,
        name: event.name,
        micEnabled: event.micEnabled,
        cameraEnabled: event.cameraEnabled,
      );
      emit(InterviewConnected(session));
    } catch (error) {
      emit(InterviewError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLeaveInterview(
    LeaveInterview event,
    Emitter<InterviewState> emit,
  ) async {
    try {
      final session = await _repository.leaveMeeting(event.session);
      emit(InterviewEnded(session));
    } catch (error) {
      emit(InterviewError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onToggleMute(
    ToggleMute event,
    Emitter<InterviewState> emit,
  ) async {
    try {
      final session = await _repository.toggleMute(event.session, event.muted);
      emit(InterviewConnected(session));
    } catch (error) {
      emit(InterviewError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onToggleCamera(
    ToggleCamera event,
    Emitter<InterviewState> emit,
  ) async {
    try {
      final session = await _repository.toggleCamera(event.session, event.enabled);
      emit(InterviewConnected(session));
    } catch (error) {
      emit(InterviewError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSwitchCamera(
    SwitchCamera event,
    Emitter<InterviewState> emit,
  ) async {
    try {
      final session = await _repository.switchCamera(event.session);
      emit(InterviewConnected(session));
    } catch (error) {
      emit(InterviewError(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
