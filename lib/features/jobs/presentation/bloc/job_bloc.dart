import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/job_repository_impl.dart';
import '../../domain/entities/job_match.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc({
    required this._repository,
  })  : super(JobInitial()) {
    on<LoadJobs>(_onLoadJobs);
    on<SearchJobs>(_onSearchJobs);
    on<ChangeCountryFilter>(_onChangeCountryFilter);
    on<ToggleFavoriteJob>(_onToggleFavoriteJob);
    on<ApplyJob>(_onApplyJob);
  }

  final JobRepository _repository;

  Future<void> _onLoadJobs(LoadJobs event, Emitter<JobState> emit) async {
    final country = event.country;
    emit(JobLoading(country: country));

    try {
      final jobs = await _repository.getJobsMatches(country: country, page: 1);
      final applied = await _repository.getAppliedJobs();

      emit(
        JobLoaded(
          jobs: jobs,
          filteredJobs: jobs,
          savedJobIds: applied,
          searchTerm: '',
          selectedCountry: country,
          isOffline: false,
          lastErrorMessage: null,
        ),
      );
    } catch (error) {
      final cached = await _repository.getJobsMatches(country: country, page: 1);
      emit(
        JobLoaded(
          jobs: cached,
          filteredJobs: cached,
          savedJobIds: await _repository.getAppliedJobs(),
          searchTerm: '',
          selectedCountry: country,
          isOffline: true,
          lastErrorMessage: 'You\'re offline — showing saved jobs',
        ),
      );
    }
  }

  Future<void> _onSearchJobs(SearchJobs event, Emitter<JobState> emit) async {
    final currentState = state;
    if (currentState is! JobLoaded) return;

    final query = event.query.trim().toLowerCase();
    final filteredJobs = query.isEmpty
        ? currentState.jobs
        : currentState.jobs.where((job) {
            final searchableText = '${job.title} ${job.employerDisplay} ${job.city} ${job.country}'.toLowerCase();
            return searchableText.contains(query);
          }).toList();

    emit(
      JobLoaded(
        jobs: currentState.jobs,
        filteredJobs: filteredJobs,
        savedJobIds: currentState.savedJobIds,
        searchTerm: event.query,
        selectedCountry: currentState.selectedCountry,
        isOffline: currentState.isOffline,
        lastErrorMessage: currentState.lastErrorMessage,
      ),
    );
  }

  Future<void> _onChangeCountryFilter(
    ChangeCountryFilter event,
    Emitter<JobState> emit,
  ) async {
    add(LoadJobs(country: event.country, refresh: true));
  }

  Future<void> _onToggleFavoriteJob(
    ToggleFavoriteJob event,
    Emitter<JobState> emit,
  ) async {
    final currentState = state;
    if (currentState is! JobLoaded) return;

    final updatedSavedJobs = Set<String>.from(currentState.savedJobIds);
    if (updatedSavedJobs.contains(event.jobId)) {
      updatedSavedJobs.remove(event.jobId);
    } else {
      updatedSavedJobs.add(event.jobId);
    }

    emit(
      JobLoaded(
        jobs: currentState.jobs,
        filteredJobs: currentState.filteredJobs,
        savedJobIds: updatedSavedJobs,
        searchTerm: currentState.searchTerm,
        selectedCountry: currentState.selectedCountry,
        isOffline: currentState.isOffline,
        lastErrorMessage: currentState.lastErrorMessage,
      ),
    );
  }

  Future<void> _onApplyJob(ApplyJob event, Emitter<JobState> emit) async {
    final currentState = state;
    if (currentState is! JobLoaded) return;

    final hasOffline = currentState.isOffline;
    if (hasOffline) {
      emit(
        JobLoaded(
          jobs: currentState.jobs,
          filteredJobs: currentState.filteredJobs,
          savedJobIds: currentState.savedJobIds,
          searchTerm: currentState.searchTerm,
          selectedCountry: currentState.selectedCountry,
          isOffline: true,
          lastErrorMessage: 'Apply is unavailable offline. Please reconnect to continue.',
        ),
      );
      return;
    }

    final previous = Set<String>.from(currentState.savedJobIds);
    final updated = Set<String>.from(currentState.savedJobIds)..add(event.jobId);
    emit(
      JobLoaded(
        jobs: currentState.jobs,
        filteredJobs: currentState.filteredJobs,
        savedJobIds: updated,
        searchTerm: currentState.searchTerm,
        selectedCountry: currentState.selectedCountry,
        isOffline: false,
        lastErrorMessage: null,
      ),
    );

    try {
      await _repository.applyForJob(event.jobId);
    } catch (_) {
      emit(
        JobLoaded(
          jobs: currentState.jobs,
          filteredJobs: currentState.filteredJobs,
          savedJobIds: previous,
          searchTerm: currentState.searchTerm,
          selectedCountry: currentState.selectedCountry,
          isOffline: false,
          lastErrorMessage: 'Apply failed. Please try again.',
        ),
      );
    }
  }
}
