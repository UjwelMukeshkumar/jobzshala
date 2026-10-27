import 'dart:math';

import '../../domain/entities/job_match.dart';

class MockJobApi {
  MockJobApi();

  final _random = Random();

  Future<List<JobMatch>> getMatches({
    String country = 'All',
    int page = 1,
  }) async {
    await _simulateNetworkDelay();

    if (_shouldFail()) {
      throw Exception('Server error');
    }

    final countries = ['UAE', 'Saudi Arabia', 'Qatar'];
    final jobList = <JobMatch>[];

    for (int i = 0; i < 200; i++) {
      final countryName = countries[i % countries.length];
      final filteredCountry = country == 'All' || countryName == country;
      if (!filteredCountry) {
        continue;
      }

      final titlePool = [
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

      final employerPool = [
        'Logistics company',
        'Facility management group',
        'Construction firm',
        'Retail chain',
        'Hospitality group',
        'Industrial services company',
      ];

      final cityPool = {
        'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah'],
        'Saudi Arabia': ['Riyadh', 'Jeddah', 'Dammam'],
        'Qatar': ['Doha', 'Al Rayyan', 'Al Wakrah'],
      };

      final countryKey = countryName;
      final city = cityPool[countryKey]![i % cityPool[countryKey]!.length];
      final title = titlePool[i % titlePool.length];
      final matchScore = 68 + (i % 30) + (_random.nextDouble() * 10);
      final minSalary = 2000 + ((i * 111) % 2600);
      final maxSalary = minSalary + 600 + ((i * 67) % 1200);

      jobList.add(
        JobMatch(
          id: 'job_${1000 + i}',
          title: title,
          employerDisplay: '${employerPool[i % employerPool.length]}, $countryKey',
          country: countryKey,
          city: city,
          salaryMinAed: minSalary,
          salaryMaxAed: maxSalary,
          matchScore: double.parse(matchScore.toStringAsFixed(1)),
          matchReason:
              '${(i % 8) + 3} years of relevant experience and valid work documentation',
          skills: _skillsForJob(title),
          benefits: JobBenefits(
            accommodation: i % 2 == 0,
            food: i % 3 != 0,
            visa: true,
          ),
          description: 'Work in a structured environment with transport, safe conditions, and supportive management.',
          requirements: [
            'Minimum 1+ years relevant experience',
            'Valid identification and work documents',
            'Ability to work in a team environment',
          ],
          postedAt: DateTime.now().subtract(Duration(days: i % 21)),
        ),
      );
    }

    jobList.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    final start = (page - 1) * 20;
    final end = start + 20;
    return jobList.sublist(
      start,
      end > jobList.length ? jobList.length : end,
    );
  }

  Future<JobMatch> getJobById(String id) async {
    await _simulateNetworkDelay();

    if (_shouldFail()) {
      throw Exception('Server error');
    }

    final allJobs = await getMatches(country: 'All');
    final match = allJobs.firstWhere(
      (job) => job.id == id,
      orElse: () => allJobs.first,
    );

    return match;
  }

  Future<void> applyForJob(String id) async {
    await _simulateNetworkDelay();

    if (_shouldFail()) {
      throw Exception('Apply failed');
    }
  }

  Future<void> _simulateNetworkDelay() async {
    final delayMs = 800 + _random.nextInt(700);
    await Future<void>.delayed(Duration(milliseconds: delayMs));
  }

  bool _shouldFail() => _random.nextInt(5) == 0;

  List<String> _skillsForJob(String title) {
    final map = {
      'Heavy Truck Driver': ['Heavy vehicle', 'Route planning', 'GCC licence'],
      'Electrician': ['Electrical repair', 'Wiring', 'Safety checks'],
      'Welder': ['Arc welding', 'Metal work', 'Safety gear'],
      'Retail Sales Associate': ['Cash handling', 'Customer service', 'Stocking'],
      'Housekeeping Supervisor': ['Cleaning', 'Team management', 'Guest service'],
      'Forklift Operator': ['Forklift', 'Loading', 'Warehouse safety'],
      'Construction Worker': ['Site work', 'Tool use', 'Safety'],
      'HVAC Technician': ['AC repair', 'Maintenance', 'Diagnostics'],
      'Kitchen Helper': ['Food prep', 'Sanitation', 'Team support'],
      'Security Guard': ['Surveillance', 'Reporting', 'Patrol'],
    };

    return map[title] ?? ['Relevant experience', 'Safety', 'Teamwork'];
  }
}
