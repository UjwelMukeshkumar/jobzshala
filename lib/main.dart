import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/jobs/data/repositories/job_repository_impl.dart';
import 'features/jobs/presentation/bloc/job_bloc.dart';
import 'features/jobs/presentation/pages/job_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = JobRepository();

    return MaterialApp(
      title: 'Jobzshala',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (_) => JobBloc(repository: repository)..add(const LoadJobs()),
        child: const JobListPage(),
      ),
    );
  }
}
