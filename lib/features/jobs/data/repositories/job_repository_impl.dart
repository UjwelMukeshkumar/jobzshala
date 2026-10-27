import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/job_match.dart';
import '../datasources/mock_job_api.dart';

 class JobRepository {
  JobRepository({
    MockJobApi? api,
    this._preferences,
  })  : _api = api ?? MockJobApi();

  final MockJobApi _api;
  final SharedPreferences? _preferences;

  static const String _appliedJobsKey = 'applied_jobs';

  Future<List<JobMatch>> getJobsMatches({
    required String country,
    required int page,
  }) async {
    final jobs = await _api.getMatches(country: country, page: page);
    return jobs;
  }

  Future<JobMatch> getJobById(String id) async {
    return _api.getJobById(id);
  }

  Future<void> applyForJob(String id) async {
    await _api.applyForJob(id);
    final current = await getAppliedJobs();
    current.add(id);
    await saveAppliedJobs(current);
  }

  Future<Set<String>> getAppliedJobs() async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_appliedJobsKey) ?? <String>[];
    return ids.toSet();
  }

  Future<void> saveAppliedJobs(Set<String> ids) async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    await prefs.setStringList(_appliedJobsKey, ids.toList());
  }
}
