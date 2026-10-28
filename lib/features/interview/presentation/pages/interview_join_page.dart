import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/interview_bloc.dart';
import 'interview_call_page.dart';

class InterviewJoinPage extends StatefulWidget {
  const InterviewJoinPage({super.key});

  @override
  State<InterviewJoinPage> createState() => _InterviewJoinPageState();
}

class _InterviewJoinPageState extends State<InterviewJoinPage> {
  bool _micEnabled = true;
  bool _cameraEnabled = true;
  bool _isJoining = false;

  Future<bool> _requestPermissions() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }

    final status = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (status.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
      if (!mounted) return false;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Camera or mic access required'),
          content: const Text(
            'Please allow camera and microphone access in app settings to continue with the interview.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
      return false;
    }

    if (status.isDenied || micStatus.isDenied) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and microphone access are needed to join the interview.'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _joinInterview() async {
    setState(() => _isJoining = true);

    try {
      final granted = await _requestPermissions();
      if (!mounted) return;
      if (!granted) return;

      final bloc = context.read<InterviewBloc>();
      bloc.add(
        JoinInterview(
          meetingCode: 'JZ-8P4Q',
          name: 'Candidate',
          micEnabled: _micEnabled,
          cameraEnabled: _cameraEnabled,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterviewBloc, InterviewState>(
      listener: (context, state) {
        if (state is InterviewConnected) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => InterviewCallPage(session: state.session),
            ),
          );
          return;
        }

        if (state is InterviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your interview'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Interview details',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Meeting code', style: TextStyle(color: Colors.blueGrey)),
                      SizedBox(height: 4),
                      Text(
                        'JZ-8P4Q',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text('Support team • 4:00 PM'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Preview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Microphone'),
                  subtitle: const Text('Enabled before joining'),
                  value: _micEnabled,
                  onChanged: (value) => setState(() => _micEnabled = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Camera'),
                  subtitle: const Text('Visible to the interviewer'),
                  value: _cameraEnabled,
                  onChanged: (value) => setState(() => _cameraEnabled = value),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isJoining ? null : _joinInterview,
                    icon: _isJoining
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.video_call_rounded),
                    label: Text(_isJoining ? 'Joining...' : 'Join interview'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
