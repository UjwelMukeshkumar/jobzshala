# Jobzshala

A Flutter app for the Jobzshala GCC hiring flow, including the Job Matches screen and the interview pre-join / live-call experience for Part B.

## State management choice

This project uses Flutter BLoC for the job list and apply flow because it keeps network state, offline fallbacks, filters, and optimistic apply updates easy to reason about in a predictable, testable way.

## Part B notes

- The Android app exposes a native MethodChannel/EventChannel bridge in `MainActivity`.
- The Flutter side uses `ChimeBridge` to issue join, leave, mute, camera and switch-camera commands.
- The app includes a `Your interview` card on the jobs list, a pre-join screen with camera/mic toggles, and a call screen with call controls and reconnecting state.
- This core implementation is designed to slot into the official Amazon Chime Android SDK when the meeting credentials and SDK dependency are added in a real production environment.

## Getting started

```bash
flutter pub get
flutter run
```

This project targets Android for the interview flow and keeps the UI lightweight enough for low-end devices.

#