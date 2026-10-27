// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jobzshala/core/theme/app_theme.dart';
import 'package:jobzshala/features/jobs/data/repositories/job_repository_impl.dart';
import 'package:jobzshala/features/jobs/domain/entities/job_match.dart';
import 'package:jobzshala/features/jobs/presentation/bloc/job_bloc.dart';
import 'package:jobzshala/features/jobs/presentation/pages/job_list_page.dart';

class FakeJobRepository extends JobRepository {
  final List<JobMatch> _jobs = [
    JobMatch(
      id: 'job_1001',
      title: 'Heavy Truck Driver',
      employerDisplay: 'Logistics company, UAE',
      country: 'UAE',
      city: 'Dubai',
      salaryMinAed: 3000,
      salaryMaxAed: 4200,
      matchScore: 92.4,
      matchReason: 'Strong driver background and willingness to relocate.',
      skills: ['Heavy vehicle', 'Route planning', 'GCC licence'],
      benefits: const JobBenefits(
        accommodation: true,
        food: true,
        visa: true,
      ),
      description: 'Drive and coordinate transport routes securely and on time.',
      requirements: ['1+ years driving experience', 'Valid license', 'Good safety habits'],
      postedAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<JobMatch>> getJobsMatches({
    required String country,
    required int page,
  }) async {
    return _jobs;
  }

  @override
  Future<JobMatch> getJobById(String id) async {
    return _jobs.firstWhere((job) => job.id == id);
  }

  @override
  Future<void> applyForJob(String id) async {}

  @override
  Future<Set<String>> getAppliedJobs() async => <String>{};

  @override
  Future<void> saveAppliedJobs(Set<String> ids) async {}
}

void main() {
  testWidgets('app shows the Jobzshala title and job list content',
      (WidgetTester tester) async {
    final repository = FakeJobRepository();
    final bloc = JobBloc(repository: repository);

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => bloc..add(const LoadJobs()),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const JobListPage(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Jobzshala'), findsOneWidget);
    expect(find.text('Job Matches'), findsOneWidget);
    expect(find.text('Heavy Truck Driver'), findsOneWidget);
  });
}
