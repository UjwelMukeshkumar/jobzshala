import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/job_match.dart';
import '../datasources/mock_job_api.dart';

class JobRepository {
  JobRepository({
    MockJobApi? api,
    SharedPreferences? preferences,
  })  : _api = api ?? MockJobApi(),
        _preferences = preferences;

  final MockJobApi _api;
  final SharedPreferences? _preferences;

  static const String _appliedJobsKey = 'applied_jobs';

  final List<JobMatch> _cache = <JobMatch>[];

  Future<List<JobMatch>> getJobsMatches({
    required String country,
    required int page,
  }) async {
    try {
      final jobs = await _api.getMatches(country: country, page: page);
      _cache
        ..clear()
        ..addAll(jobs);
      return jobs;
    } catch (_) {
      if (_cache.isNotEmpty) {
        return List<JobMatch>.from(_cache);
      }
      throw Exception('No jobs available offline');
    }
  }

  Future<JobMatch> getJobById(String id) async {
    try {
      return await _api.getJobById(id);
    } catch (_) {
      if (_cache.isNotEmpty) {
        return _cache.firstWhere(
          (job) => job.id == id,
          orElse: () => _cache.first,
        );
      }
      throw Exception('Job not available offline');
    }
  }

  Future<void> applyForJob(String id) async {
    await _api.applyForJob(id);
    final saved = await getAppliedJobs();
    saved.add(id);
    await saveAppliedJobs(saved);
  }

  Future<Set<String>> getAppliedJobs() async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_appliedJobsKey) ?? <String>[];
    return saved.toSet();
  }

  Future<void> saveAppliedJobs(Set<String> ids) async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    await prefs.setStringList(_appliedJobsKey, ids.toList());
  }
}
