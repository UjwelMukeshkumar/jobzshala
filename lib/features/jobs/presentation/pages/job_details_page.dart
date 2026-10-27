import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobzshala/features/jobs/presentation/widgets/benifit.dart';

import '../../domain/entities/job_match.dart';
import '../bloc/job_bloc.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({
    super.key,
    required this.job,
    required this.isApplied,
    required this.isOffline,
  });

  final JobMatch job;
  final bool isApplied;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobzshala'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.employerDisplay,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${job.country} • ${job.city}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${job.matchScore.toStringAsFixed(1)}% match',
                          style: const TextStyle(
                            color: Color(0xFF2F6FED),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isApplied)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: const Text(
                            'Applied',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AED ${job.salaryMinAed} - ${job.salaryMaxAed} / month',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.description,
                    style: const TextStyle(height: 1.7, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Requirements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...job.requirements.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 18)),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                    BenefitRow(label: 'Accommodation', value: job.benefits.accommodation),
                    BenefitRow(label: 'Food', value: job.benefits.food),
                    BenefitRow(label: 'Visa', value: job.benefits.visa),
                  const SizedBox(height: 24),
                  const Text(
                    'AI Match Reason',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.matchReason,
                    style: const TextStyle(fontSize: 15, height: 1.7),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(skill),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: isOffline || isApplied
                      ? null
                      : () {
                          context.read<JobBloc>().add(ApplyJob(job.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Application sent successfully!'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6FED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isApplied ? 'Applied' : 'Apply',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


