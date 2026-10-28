// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class WebCameraView extends StatefulWidget {
  const WebCameraView({super.key, required this.enabled});

  final bool enabled;

  @override
  State<WebCameraView> createState() => _WebCameraViewState();
}

class _WebCameraViewState extends State<WebCameraView> {
  late final String _viewType;
  html.VideoElement? _videoElement;
  bool _hasPermissionError = false;

  @override
  void initState() {
    super.initState();
    _viewType = 'jobzshala-web-camera-${DateTime.now().microsecondsSinceEpoch}';
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.transform = 'scaleX(-1)';
    _videoElement!.setAttribute('playsinline', 'true');

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      return _videoElement!;
    });

    _startCameraIfNeeded();
  }

  @override
  void didUpdateWidget(covariant WebCameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled == widget.enabled) {
      return;
    }
    _startCameraIfNeeded();
  }

  Future<void> _startCameraIfNeeded() async {
    if (_videoElement == null) return;

    if (!widget.enabled) {
      _stopCamera();
      if (mounted) {
        setState(() {
          _hasPermissionError = false;
        });
      }
      return;
    }

    try {
      final mediaStream = await html.window.navigator.mediaDevices
          ?.getUserMedia(<String, dynamic>{'video': true, 'audio': false});
      _videoElement!.srcObject = mediaStream;
      await _videoElement!.play();
      if (mounted) {
        setState(() {
          _hasPermissionError = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasPermissionError = true;
        });
      }
    }
  }

  void _stopCamera() {
    final stream = _videoElement?.srcObject;
    if (stream is html.MediaStream) {
      for (final track in stream.getTracks()) {
        track.stop();
      }
    }
    if (_videoElement != null) {
      _videoElement!.srcObject = null;
    }
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasPermissionError) {
      return Container(
        color: const Color(0xFF1C2430),
        alignment: Alignment.center,
        child: const Text(
          'Camera permission denied in browser',
          style: TextStyle(color: Colors.white70, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!widget.enabled) {
      return Container(
        color: const Color(0xFF1C2430),
        alignment: Alignment.center,
        child: const Icon(Icons.videocam_off, color: Colors.white70, size: 36),
      );
    }

    return HtmlElementView(viewType: _viewType);
  }
}
