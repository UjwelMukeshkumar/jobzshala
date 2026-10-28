import 'package:flutter/material.dart';

class WebCameraView extends StatelessWidget {
  const WebCameraView({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C2430),
      child: Center(
        child: Icon(
          enabled ? Icons.videocam : Icons.videocam_off,
          color: Colors.white70,
          size: 36,
        ),
      ),
    );
  }
}
