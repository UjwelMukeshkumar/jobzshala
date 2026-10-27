import 'package:equatable/equatable.dart';

class JobMatch extends Equatable {
  const JobMatch({
    required this.id,
    required this.title,
    required this.employerDisplay,
    required this.country,
    required this.city,
    required this.salaryMinAed,
    required this.salaryMaxAed,
    required this.matchScore,
    required this.matchReason,
    required this.skills,
    required this.benefits,
    required this.description,
    required this.requirements,
    required this.postedAt,
  });

  final String id;
  final String title;
  final String employerDisplay;
  final String country;
  final String city;
  final int salaryMinAed;
  final int salaryMaxAed;
  final double matchScore;
  final String matchReason;
  final List<String> skills;
  final JobBenefits benefits;
  final String description;
  final List<String> requirements;
  final DateTime postedAt;

  String get salaryRange => 'AED ${salaryMinAed.toString()} - ${salaryMaxAed.toString()}';

  @override
  List<Object?> get props => [
    id,
    title,
    employerDisplay,
    country,
    city,
    salaryMinAed,
    salaryMaxAed,
    matchScore,
    matchReason,
    skills,
    benefits,
    description,
    requirements,
    postedAt,
  ];
}

class JobBenefits extends Equatable {
  const JobBenefits({
    required this.accommodation,
    required this.food,
    required this.visa,
  });

  final bool accommodation;
  final bool food;
  final bool visa;

  @override
  List<Object?> get props => [accommodation, food, visa];
}
