import 'dart:math';

import '../../domain/entities/job_match.dart';

class MockJobApi {
  final Random random = Random();

  Future<List<JobMatch>> getMatches({
    String country = 'All',
    int page = 1,
  }) async {
    await Future.delayed(
      Duration(milliseconds: 800 + random.nextInt(700)),
    );

    if (random.nextInt(5) == 0) {
      throw Exception('Server error');
    }

    final countries = ['UAE', 'Saudi Arabia', 'Qatar'];

    final titles = [
      'Heavy Truck Driver',
      'Electrician',
      'Welder',
      'Retail Sales Associate',
      'Housekeeping Supervisor',
      'Forklift Operator',
      'Construction Worker',
      'HVAC Technician',
      'Kitchen Helper',
      'Security Guard',
    ];

    final employers = [
      'Logistics company',
      'Facility management group',
      'Construction firm',
      'Retail chain',
      'Hospitality group',
      'Industrial services company',
    ];

    final cities = {
      'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah'],
      'Saudi Arabia': ['Riyadh', 'Jeddah', 'Dammam'],
      'Qatar': ['Doha', 'Al Rayyan', 'Al Wakrah'],
    };

    final jobs = <JobMatch>[];

    for (int i = 0; i < 200; i++) {
      final jobCountry = countries[i % 3];

      if (country != 'All' && country != jobCountry) {
        continue;
      }

      final title = titles[i % titles.length];

      final salary = 2000 + (i * 111) % 2600;
// 2000 — minimum starting salary.
// i * 111 — generates a changing number for each job.
// % 2600 — keeps the result between 0 and 2599.
// 2000 + — makes the salary range from ₹2,000 to ₹4,599.
      jobs.add(
        JobMatch(
          id: 'job_${1000 + i}',
          title: title,
          employerDisplay: '${employers[i % employers.length]}, $jobCountry',
          country: jobCountry,
          city: cities[jobCountry]![i % 3],
          salaryMinAed: salary,
          salaryMaxAed: salary + 600 + (i * 67) % 1200,
          matchScore: 68 + (i % 30) + random.nextDouble() * 10,
          matchReason:
              '${(i % 8) + 3} years of relevant experience and valid work documentation',
          skills: getSkills(title),
          benefits: JobBenefits(
            accommodation: i % 2 == 0,
            food: i % 3 != 0,
            visa: true,
          ),
          description:
              'Work in a structured environment with transport, safe conditions, and supportive management.',
          requirements: [
            'Minimum 1+ years relevant experience',
            'Valid identification and work documents',
            'Ability to work in a team environment',
          ],
          postedAt: DateTime.now().subtract(
            Duration(days: i % 21),
          ),
        ),
      );
    }

    jobs.sort(
      (a, b) => b.matchScore.compareTo(a.matchScore),
    );

    final start = (page - 1) * 20;
    final end = min(start + 20, jobs.length);

    return jobs.sublist(start, end);
  }

  Future<JobMatch> getJobById(String id) async {
    await Future.delayed(
      Duration(milliseconds: 800 + random.nextInt(700)),
    );

    if (random.nextInt(5) == 0) {
      throw Exception('Server error');
    }

    final jobs = await getMatches();

    return jobs.firstWhere(
      (job) => job.id == id,
      orElse: () => jobs.first,
    );
  }

  Future<void> applyForJob(String id) async {
    await Future.delayed(
      Duration(milliseconds: 800 + random.nextInt(700)),
    );

    if (random.nextInt(5) == 0) {
      throw Exception('Apply failed');
    }
  }

  List<String> getSkills(String title) {
    if (title == 'Heavy Truck Driver') {
      return ['Heavy vehicle', 'Route planning', 'GCC licence'];
    } else if (title == 'Electrician') {
      return ['Electrical repair', 'Wiring', 'Safety checks'];
    } else if (title == 'Welder') {
      return ['Arc welding', 'Metal work', 'Safety gear'];
    } else if (title == 'Retail Sales Associate') {
      return ['Cash handling', 'Customer service', 'Stocking'];
    } else if (title == 'Housekeeping Supervisor') {
      return ['Cleaning', 'Team management', 'Guest service'];
    } else if (title == 'Forklift Operator') {
      return ['Forklift', 'Loading', 'Warehouse safety'];
    } else if (title == 'Construction Worker') {
      return ['Site work', 'Tool use', 'Safety'];
    } else if (title == 'HVAC Technician') {
      return ['AC repair', 'Maintenance', 'Diagnostics'];
    } else if (title == 'Kitchen Helper') {
      return ['Food prep', 'Sanitation', 'Team support'];
    } else if (title == 'Security Guard') {
      return ['Surveillance', 'Reporting', 'Patrol'];
    }

    return ['Relevant experience', 'Safety', 'Teamwork'];
  }
}