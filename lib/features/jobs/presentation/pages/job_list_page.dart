import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobzshala/features/interview/domain/repositories/interview_repository.dart';

import '../../../interview/presentation/bloc/interview_bloc.dart';
import '../../../interview/presentation/pages/interview_join_page.dart';
import '../bloc/job_bloc.dart';
import 'job_details_page.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobzshala'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text('Akshaki India Pvt. Ltd.'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<JobBloc>().add(
            LoadJobs(country: 'All', refresh: true),
          );
        },
        child: BlocBuilder<JobBloc, JobState>(
          builder: (context, state) {
            if (state is JobLoading) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading job matches...'),
                  ],
                ),
              );
            }

            if (state is JobError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 46),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<JobBloc>().add(LoadJobs(country: state.country));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is JobLoaded) {
              final jobs = state.filteredJobs;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Job Matches',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (state.isOffline)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: const Text(
                                'You\'re offline — showing saved jobs',
                                style: TextStyle(color: Color(0xFF9A5B00)),
                              ),
                            ),
                          if (state.lastErrorMessage != null && !state.isOffline)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                state.lastErrorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: ['All', 'UAE', 'Saudi Arabia', 'Qatar']
                                  .map(
                                    (country) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        label: Text(country),
                                        selected: state.selectedCountry == country,
                                        onSelected: (_) {
                                          context.read<JobBloc>().add(
                                            ChangeCountryFilter(country),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1FF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Your interview',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text('Meeting code: JZ-8P4Q'),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (_) => InterviewBloc(
                                            repository: InterviewRepositoryImpl(),
                                          ),
                                          child: const InterviewJoinPage(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.video_call_rounded),
                                  label: const Text('Join'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged: (value) {
                              context.read<JobBloc>().add(SearchJobs(value));
                            },
                            decoration: InputDecoration(
                              hintText: 'Search jobs',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (jobs.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.search_off_rounded, size: 48),
                            SizedBox(height: 12),
                            Text('No matches yet'),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final job = jobs[index];
                          final isApplied = state.savedJobIds.contains(job.id);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                final bloc = context.read<JobBloc>();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: bloc,
                                      child: JobDetailsPage(
                                        job: job,
                                        isApplied: isApplied,
                                        isOffline: state.isOffline,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            job.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEAF1FF),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            '${job.matchScore.toStringAsFixed(1)}%',
                                            style: const TextStyle(
                                              color: Color(0xFF2F6FED),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      job.employerDisplay,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${job.country} • ${job.city}',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'AED ${job.salaryMinAed} - ${job.salaryMaxAed} / month',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: job.skills.take(3).map((skill) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            skill,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            isApplied ? 'Applied' : 'Not applied yet',
                                            style: TextStyle(
                                              color: isApplied
                                                  ? Colors.green.shade700
                                                  : Colors.grey.shade700,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: jobs.length,
                      ),
                    ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
