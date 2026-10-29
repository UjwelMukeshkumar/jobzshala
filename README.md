# Jobzshala

Simple Flutter app for the Jobzshala GCC assignment.

This app includes:
- **Part A:** Job matches flow (list, details, apply)
- **Part B:** Interview flow with camera/mic controls and call UI

---

## 1) What is built

### Part A - Job Matches
- Job list with:
  - title
  - employer display name
  - country and city
  - salary range (AED/month)
  - match score (%)
  - skill chips
- Country filter (All / UAE / Saudi Arabia / Qatar)
- Search field
- Pull-to-refresh
- Loading / empty / error states
- Offline fallback banner
- Job details page with:
  - description
  - requirements
  - benefits
  - AI match reason
- Apply flow:
  - optimistic update
  - rollback on failure
  - applied status persisted with `SharedPreferences`

### Part B - Interview
- "Your interview" card in Job Matches screen
- Pre-join screen:
  - camera and microphone toggles
  - permission handling
- Live call screen:
  - local self-view area
  - controls: mute, camera, switch, leave
  - participant count
  - call timer
  - reconnecting banner
- Uses **`flutter_amazon_chime`** through one service:
  - [interview_service.dart](./lib/features/interview/services/interview_service.dart)

---

## 2) Tech stack

- Flutter + Dart (null safety)
- State management: `flutter_bloc`
- Local storage: `shared_preferences`
- Permissions: `permission_handler`
- Interview SDK package: `flutter_amazon_chime`

---

## 3) Project structure (easy view)

```text
lib/
  core/
  features/
    jobs/
      data/
      domain/
      presentation/
    interview/
      data/
      domain/
      presentation/
      services/
```

- `data`: repository implementations
- `domain`: entities + repository contracts
- `presentation`: pages + bloc
- `services`: platform/sdk service helpers

---

## 4) Important interview files

- Service (single entry):
  - [lib/features/interview/services/interview_service.dart](./lib/features/interview/services/interview_service.dart)
- Join page:
  - [lib/features/interview/presentation/pages/interview_join_page.dart](./lib/features/interview/presentation/pages/interview_join_page.dart)
- Call page:
  - [lib/features/interview/presentation/pages/interview_call_page.dart](./lib/features/interview/presentation/pages/interview_call_page.dart)
- Interview Bloc:
  - [lib/features/interview/presentation/bloc/interview_bloc.dart](./lib/features/interview/presentation/bloc/interview_bloc.dart)
  - [lib/features/interview/presentation/bloc/interview_event.dart](./lib/features/interview/presentation/bloc/interview_event.dart)
  - [lib/features/interview/presentation/bloc/interview_state.dart](./lib/features/interview/presentation/bloc/interview_state.dart)

---

## 5) Setup and run

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- Android emulator or physical Android device

### Install
```bash
flutter pub get
```

### Run
```bash
flutter run
```

### Useful commands
```bash
flutter analyze
flutter test
```

---

## 6) Platform notes

- **Android:** primary target for interview flow
- **Web:** app runs; web local camera preview is supported in call UI
- `AndroidManifest.xml` already includes required camera/mic related permissions

---

## 7) Current behavior and limitations

- Backend is mocked for assignment flow behavior (delay + random failures)
- Interview meeting credentials are still mocked/hardcoded in UI flow
- Chime package is integrated, but production meeting join should use real `/join` endpoint data (`Meeting` + `Attendee`)
- UI is intentionally kept simple and lightweight for clarity

---

## 8) Why BLoC here

`flutter_bloc` was chosen to keep async states predictable and easy to test:
- loading / success / error states
- offline fallback
- optimistic apply updates
- interview join/call transitions

---

## 9) Testing

- Widget test included in:
  - [test/widget_test.dart](./test/widget_test.dart)
- Run:
```bash
flutter test
```

---

## 10) Next improvements (optional)

- Connect interview flow to real backend join API
- Add full i18n (English/Hindi) labels for all interview UI text
- Add more unit tests for interview service and bloc
- Add full remote participant video tiles from real meeting data