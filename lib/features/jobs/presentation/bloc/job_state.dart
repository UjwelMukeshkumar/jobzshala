part of 'job_bloc.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {
  const JobLoading({this.country = 'All'});

  final String country;

  @override
  List<Object?> get props => [country];
}

class JobLoaded extends JobState {
  const JobLoaded({
    required this.jobs,
    required this.filteredJobs,
    required this.savedJobIds,
    required this.searchTerm,
    required this.selectedCountry,
    required this.isOffline,
    required this.lastErrorMessage,
  });

  final List<JobMatch> jobs;
  final List<JobMatch> filteredJobs;
  final Set<String> savedJobIds;
  final String searchTerm;
  final String selectedCountry;
  final bool isOffline;
  final String? lastErrorMessage;

  @override
  List<Object?> get props => [
    jobs,
    filteredJobs,
    savedJobIds,
    searchTerm,
    selectedCountry,
    isOffline,
    lastErrorMessage,
  ];
}

class JobError extends JobState {
  const JobError(this.message, {this.country = 'All'});

  final String message;
  final String country;

  @override
  List<Object?> get props => [message, country];
}
