import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/interview_session.dart';
import '../../services/chime_bridge.dart';
import '../widgets/web_camera_view.dart';

class InterviewCallPage extends StatefulWidget {
  const InterviewCallPage({super.key, required this.session});

  final InterviewSession session;

  @override
  State<InterviewCallPage> createState() => _InterviewCallPageState();
}

class _InterviewCallPageState extends State<InterviewCallPage>
    with WidgetsBindingObserver {
  late final StreamSubscription<Map<String, dynamic>> _subscription;
  bool _isMuted = false;
  bool _cameraEnabled = true;
  bool _isReconnecting = false;
  int _participantCount = 2;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isMuted = widget.session.isMuted;
    _cameraEnabled = widget.session.cameraEnabled;
    _participantCount = widget.session.participantCount;
    _startTimer();
    WidgetsBinding.instance.addObserver(this);
    _subscription = ChimeBridge.events.listen((event) {
      final eventName = event['event'] as String? ?? '';
      final payload = event['payload'] as Map<String, dynamic>? ?? const {};

      switch (eventName) {
        case 'sessionStarted':
          break;
        case 'attendeeJoined':
          setState(() => _participantCount += 1);
          break;
        case 'attendeeLeft':
          setState(() => _participantCount = (_participantCount - 1).clamp(1, 12));
          break;
        case 'muteStateChanged':
          setState(() => _isMuted = payload['muted'] as bool? ?? false);
          break;
        case 'videoTileAdded':
          setState(() => _cameraEnabled = payload['cameraEnabled'] as bool? ?? true);
          break;
        case 'connectionPoor':
          setState(() => _isReconnecting = true);
          break;
        case 'connectionRecovered':
          setState(() => _isReconnecting = false);
          break;
        case 'sessionStopped':
          if (mounted) Navigator.of(context).maybePop();
          break;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _timer?.cancel();
    ChimeBridge.leaveMeeting();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      ChimeBridge.leaveMeeting();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _elapsed = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _toggleMute() async {
    final muted = !_isMuted;
    setState(() => _isMuted = muted);
    await ChimeBridge.toggleMute(muted: muted);
  }

  Future<void> _toggleCamera() async {
    final enabled = !_cameraEnabled;
    setState(() => _cameraEnabled = enabled);
    await ChimeBridge.toggleCamera(enabled: enabled);
  }

  Future<void> _switchCamera() async {
    await ChimeBridge.switchCamera();
  }

  String _formatTimer(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.black87,
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 88,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: SizedBox(
                          width: 110,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C2430),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                children: [
                                  if (kIsWeb)
                                    Positioned.fill(
                                      child: WebCameraView(enabled: _cameraEnabled),
                                    )
                                  else
                                    Center(
                                      child: Icon(
                                        _cameraEnabled ? Icons.videocam : Icons.videocam_off,
                                        color: Colors.white70,
                                        size: 40,
                                      ),
                                    ),
                                  Positioned(
                                    left: 10,
                                    right: 10,
                                    bottom: 8,
                                    child: Text(
                                      _cameraEnabled ? 'You' : 'Camera off',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_isReconnecting)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Reconnecting…',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Live interview',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '$_participantCount participants',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Call time: ${_formatTimer(_elapsed)}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person_outline_rounded, size: 70),
                                  SizedBox(height: 12),
                                  Text('Interviewer', style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 8),
                                  Text('Camera is off', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _controlButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: _isMuted ? 'Unmute' : 'Mute',
                      onPressed: _toggleMute,
                    ),
                    _controlButton(
                      icon: _cameraEnabled ? Icons.videocam : Icons.videocam_off,
                      label: _cameraEnabled ? 'Camera on' : 'Camera off',
                      onPressed: _toggleCamera,
                    ),
                    _controlButton(
                      icon: Icons.switch_camera,
                      label: 'Switch',
                      onPressed: _switchCamera,
                    ),
                    _controlButton(
                      icon: Icons.call_end,
                      label: 'Leave',
                      onPressed: () async {
                        final navigationContext = context;
                        await ChimeBridge.leaveMeeting();
                        if (!mounted) return;
                        if (!navigationContext.mounted) return;
                        Navigator.of(navigationContext).maybePop();
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required Future<void> Function() onPressed,
    Color color = const Color(0xFF2F6FED),
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async => onPressed(),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
