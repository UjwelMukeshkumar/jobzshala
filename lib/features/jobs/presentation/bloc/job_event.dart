part of 'job_bloc.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object?> get props => [];
}

class LoadJobs extends JobEvent {
  const LoadJobs({this.country = 'All', this.refresh = false});

  final String country;
  final bool refresh;

  @override
  List<Object?> get props => [country, refresh];
}

class SearchJobs extends JobEvent {
  const SearchJobs(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class ChangeCountryFilter extends JobEvent {
  const ChangeCountryFilter(this.country);

  final String country;

  @override
  List<Object?> get props => [country];
}

class ToggleFavoriteJob extends JobEvent {
  const ToggleFavoriteJob(this.jobId);

  final String jobId;

  @override
  List<Object?> get props => [jobId];
}

class ApplyJob extends JobEvent {
  const ApplyJob(this.jobId);

  final String jobId;

  @override
  List<Object?> get props => [jobId];
}
