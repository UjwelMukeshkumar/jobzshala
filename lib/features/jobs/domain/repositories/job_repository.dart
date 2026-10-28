import '../../domain/entities/job_match.dart';

abstract class JobRepository {
  Future<List<JobMatch>> getJobsMatches({
    required String country,
    required int page,
  });

  Future<JobMatch> getJobById(String id);

  Future<void> applyForJob(String id);

  Future<Set<String>> getAppliedJobs();

  Future<void> saveAppliedJobs(Set<String> ids);
}
