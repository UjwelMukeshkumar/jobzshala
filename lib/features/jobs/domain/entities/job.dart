import 'package:equatable/equatable.dart';

class Job extends Equatable {
  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.description,
  });

  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;
  final String description;

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    location,
    type,
    salary,
    description,
  ];
}
