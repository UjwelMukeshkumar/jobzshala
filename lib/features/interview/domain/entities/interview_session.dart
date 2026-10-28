import 'package:equatable/equatable.dart';

class InterviewSession extends Equatable {
  const InterviewSession({
    required this.meetingId,
    required this.meetingCode,
    required this.attendeeName,
    required this.isMuted,
    required this.cameraEnabled,
    required this.participantCount,
    required this.status,
  });

  final String meetingId;
  final String meetingCode;
  final String attendeeName;
  final bool isMuted;
  final bool cameraEnabled;
  final int participantCount;
  final InterviewStatus status;

  InterviewSession copyWith({
    String? meetingId,
    String? meetingCode,
    String? attendeeName,
    bool? isMuted,
    bool? cameraEnabled,
    int? participantCount,
    InterviewStatus? status,
  }) {
    return InterviewSession(
      meetingId: meetingId ?? this.meetingId,
      meetingCode: meetingCode ?? this.meetingCode,
      attendeeName: attendeeName ?? this.attendeeName,
      isMuted: isMuted ?? this.isMuted,
      cameraEnabled: cameraEnabled ?? this.cameraEnabled,
      participantCount: participantCount ?? this.participantCount,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    meetingId,
    meetingCode,
    attendeeName,
    isMuted,
    cameraEnabled,
    participantCount,
    status,
  ];
}

enum InterviewStatus {
  idle,
  joining,
  connected,
  ended,
  error,
}
