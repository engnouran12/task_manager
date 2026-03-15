# Technical Gap Analysis Report: Tadawi Task Manager

**Author:** Senior Mobile Software Architect  
**Date:** March 15, 2026  
**Project:** Task Manager  
**Reference Document:** [mobile_tech_requirements.md](./mobile_tech_requirements.md)

---

## 1. Missing Requirements

The following high-priority technical requirements from the TR document are currently absent from the project implementation.

### TR-01: Authentication & Session Management
*   **OAuth 2.0 with PKCE (TR-01-1):** 🔴 **Must.** The current app uses basic JSON/POST credentials over an unencrypted HTTP connection.
*   **Secure Storage (TR-01-2):** 🔴 **Must.** Tokens are intended for plain `SharedPreferences`, exposing them to extraction. Required: iOS Keychain / Android EncryptedSharedPreferences.
*   **Biometric Authentication (TR-01-5/6):** 🟠 **Should.** No "App-access gate" with Face ID/Fingerprint or 5-minute Auto-Lock logic.
*   **Token Refresh Logic (TR-01-3/9):** 🔴 **Must.** No automated background refresh or interceptors for `401 Unauthorized` responses.

### TR-03 & TR-10: Feature Modules
*   **Ticketing Module (TR-03):** 🔴 **Must.** Entire module is missing, including Barcode Patient Scanning and SLA Countdown UI.
*   **Meeting Module (TR-10):** 🔴 **Must.** Entire module is missing, including One-Tap Zoom Join and Local Reminders.
*   **Marketing Module (TR-04):** 🟠 **Should.** Campaign dashboards and workflow approval steps are missing.

### TR-05 & TR-06: Infrastructure
*   **Push Notifications (TR-05):** 🔴 **Must.** No FCM/APNs integration or deep-link routing (`tadawi://`).
*   **Offline Capacity (TR-06):** 🟠 **Should.** No local encrypted database (Hive/SQLite) or sync queue.
*   **Local Encryption (TR-06-7):** 🔴 **Must.** All cached data must be encrypted with AES-256-GCM; this is not implemented.

### TR-11: Security Hardening
*   **Certificate Pinning (TR-11-2):** 🔴 **Must.** No public key hash pinning for `api.tadawi.com`.
*   **TLS 1.3 Enforcement (TR-11-1):** 🔴 **Must.** Current implementation uses `http`, which is a critical security breach.
*   **Root/Jailbreak Detection (TR-11-3):** 🟠 **Should.** No protection against compromised devices.

---

## 2. Partially Implemented Requirements

| Requirement | ID | Status / Gap |
| :--- | :--- | :--- |
| **Tasks Module** | TR-02 | UI exists but lacks backend API field filtering (TR-02-1), 6-state status & colors (TR-02-2), Quick Complete bottom sheet (TR-02-3), debounced Progress Slider (TR-02-4), Voice & Photo Attachments (TR-02-5/6), Quick Assign swipe (TR-02-7), Dashboard KPIs (TR-02-8), offline queue/AES caching (TR-02-9/10/11), and push notification deep-links (TR-02-12). |
| **Search & Filter** | TR-08 | Basic search UI exists, but lacks the mandatory 300ms debounce and cross-module Global Search functionality. |
| **Localization** | TR-09 | Only English is supported. No Arabic strings, RTL mirroring, or Hijri calendar support. |
| **File Uploads** | TR-07 | Basic image picking exists, but lacks mandatory compression, chunked upload for >5MB files, and background progress. |

---

## 3. Recommended Additions

1.  **Network Architecture:** Switch from standard `http` to `Dio` to utilize Interceptors for:
    *   Mandatory Headers (`X-Tenant-Id`, `X-Device-ID`, etc.)
    *   Security logging and 401 token refresh.
2.  **State Management:** Ensure all "Static" UI components (like `ProjectTaskBody`) are properly integrated with Bloc/Cubit to handle real-time data and offline states.
3.  **Local Storage:** Implement `flutter_secure_storage` for credentials and `hive` with encryption for data caching.
4.  **UI/UX:** Add a "Connectivity Banner" to satisfy **TR-06-6** (Offline mode indicator).

---

## 4. Suggested Implementation Steps

### Step 1: Security & Networking (W1)
*   Switch all API base URLs to `https`.
*   Implement `SecureStorageService` for tokens.
*   Configure `Dio` with global interceptors.

### Step 2: Auth & Localization (W2)
*   Integrate `flutter_appauth` for OAuth2+PKCE.
*   Setup `flutter_localizations` and create `intl_ar.arb` for RTL support.

### Step 3: Module Development (W3-W5)
*   **Ticketing:** Build patient lookup and SLA timer components.
*   **Meetings:** Build Zoom deep-linking and calendar integration.
*   **Push:** Setup Firebase Messaging and notification routing.

### Step 4: Hardening (W6)
*   Turn on code obfuscation in `build.gradle.kts`.
*   Implement `TrustKit` / `OkHttp` pinning.

---

## 5. Files or Areas That Need Changes

*   **`lib/core/`**: New services for `SecureStorage`, `NotificationService`, and `LocalizationHelper`.
*   **`lib/features/`**: Add directories for `ticketing`, `marketing`, and `meetings`.
*   **`lib/main.dart`**: Initialize Firebase, Localization, and Deep Link observers.
*   **`pubspec.yaml`**: Add mandatory security and infrastructure packages.
*   **`android/app/build.gradle.kts`**: Security configurations and ProGuard rules.
