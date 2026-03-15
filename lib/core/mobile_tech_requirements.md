# Tadawi Mobile - Technical Requirements
>
> Traced from: [mobile-api-brd.md](file:///c:/Users/LapShop/Downloads/mobile-api-brd.md) v1.3.0 (March 2026)
> Scope: **Mobile client features only** - server-side / admin / web features are excluded.

---

## Traceability Matrix

| BRD Section | Mobile Feature Area | TR Section |
|-------------|--------------------|-----------:|
| §2 Authentication & Security | Auth + Session | TR-01 |
| §3.4 Tasks - Mobile-Specific | Task Quick Actions & Offline | TR-02 |
| §4.4 Ticketing - Mobile-Specific | Ticket Quick Creation & SLA UI | TR-03 |
| §5.5 Marketing - Mobile-Specific | Campaign Dashboard & Offline | TR-04 |
| §6.1 Common - Push Notifications | Push Notifications | TR-05 |
| §6.2 Common - Offline Capability | Offline / Sync Strategy | TR-06 |
| §6.3 Common - File Uploads | File Upload (Mobile) | TR-07 |
| §6.4 Common - Search & Filter | Search & Filtering | TR-08 |
| §6.5 Common - Localization | Bilingual / RTL Support | TR-09 |
| §8.4 Meeting - Mobile-Specific | Meeting Quick Actions | TR-10 |
| §9 Mobile API Security | Security Hardening | TR-11 |

---

## TR-01 - Authentication & Session Management

**Source:** BRD §2.2, §2.3, §2.5, §2.6, §2.7

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-01-1 | Implement OAuth 2.0 Authorization Code Flow **with PKCE** using the TadawiSSO endpoints (`/connect/authorize`, `/connect/token`) | 🔴 Must |
| TR-01-2 | Store access token and refresh token in **iOS Keychain** / **Android EncryptedSharedPreferences (Keystore-backed)** - never in plain SharedPrefs or UserDefaults | 🔴 Must |
| TR-01-3 | Automatically refresh the access token **before expiry** (15-min TTL); use the refresh token (7-day TTL) silently in the background | 🔴 Must |
| TR-01-4 | Attach required HTTP headers to every API request: `Authorization: Bearer {token}`, `X-Tenant-Id`, `Accept-Language`, `X-Device-ID`, `X-App-Version` | 🔴 Must |
| TR-01-5 | Implement **Biometric Authentication** (Face ID / Fingerprint) as an optional app-access gate using platform LocalAuthentication / BiometricPrompt APIs | 🟠 Should |
| TR-01-6 | Enforce **Auto-Lock** after 5 min of inactivity (configurable); show biometric/PIN prompt on foreground restore | 🟠 Should |
| TR-01-7 | Enforce **Idle Timeout** at 30 min; **Absolute Timeout** at 24 h - force full re-login on absolute timeout | 🟠 Should |
| TR-01-8 | Support up to **3 concurrent device sessions**; on password change, revoke all sessions and redirect to login | 🟡 Could |
| TR-01-9 | On `401 Unauthorized`: attempt silent token refresh once; if fail, redirect to login screen | 🔴 Must |
| TR-01-10 | Implement **Secure Logout**: revoke refresh token server-side, clear Keychain/Keystore, clear in-memory data, clear cached API responses | 🔴 Must |

### API Endpoints Used

```
POST /connect/token          - initial token exchange
GET  /connect/authorize      - initiate OAuth flow
POST /connect/token          - refresh token exchange
```

---

## TR-02 - Tasks Module (Mobile Features)

**Source:** BRD §3.3, §3.4

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-02-1 | Display task list using **field-filtered** API calls to reduce payload: `fields=id,subject,status,completionRate,expectedEndDate,responsibleEmployees` | 🔴 Must |
| TR-02-2 | Implement **status color coding** in the UI: NotStarted=Gray, InProgress=Blue, Completed=Green, Failed=Red, Deferred=Orange, Pending=Yellow | 🔴 Must |
| TR-02-3 | Implement **Quick Complete** - one-tap task completion action with an optional text note bottom sheet | 🟠 Should |
| TR-02-4 | Implement **Progress Slider** - swipe/slide gesture to directly set completion % (0-100); debounce API call by 500ms | 🟠 Should |
| TR-02-5 | Implement **Voice Note** attachment - record audio, upload via `/api/uploads`, attach to task as evidence | 🟡 Could |
| TR-02-6 | Implement **Photo Attachment** - launch camera or gallery picker, compress before upload, attach to task | 🟠 Should |
| TR-02-7 | Implement **Quick Assign** - swipe-to-reassign gesture; populate assignee list from `GET /api/tasks/assignable-employees` | 🟡 Could |
| TR-02-8 | **Dashboard Widget**: show KPIs (totalTasks, completedTasks, inProgressTasks, overdueTasks, completionRate) fetched from `GET /api/dashboards/employee/analytics` | 🟠 Should |
| TR-02-9 | **Offline - Cache** last 200 task records locally; encrypt cached data with AES-256-GCM | 🟠 Should |
| TR-02-10 | **Offline - Queue Creation**: allow task creation offline; queue in local DB and auto-sync on reconnect | 🟠 Should |
| TR-02-11 | **Offline - Queue Status Updates**: queue status changes (start/complete/fail/defer) made offline; apply server-wins conflict resolution on sync | 🟠 Should |
| TR-02-12 | Send **push notification** to assignee on new task assignment and when a task is overdue (handled by backend; app must handle deep-link `tadawi://tasks/{id}`) | 🔴 Must |

### Mobile-Optimized Field Sets

| View | Fields |
|------|--------|
| Task List | `id,subject,status,completionRate,expectedEndDate,responsibleEmployees` |
| Dashboard Widget | `id,subject,status,completionRate` |
| Calendar View | `id,subject,status,expectedStartDate,expectedEndDate` |
| Task Detail | `*` (all fields) |

---

## TR-03 - Ticketing Module (Mobile Features)

**Source:** BRD §4.3, §4.4

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-03-1 | Implement **Barcode Scanner** on ticket creation to scan patient wristband/file number; auto-populate patient details via `GET /api/patients/lookup?fileNumber={id}` | 🟠 Should |
| TR-03-2 | Implement **Voice-to-Text** for dictating ticket description on mobile | 🟡 Could |
| TR-03-3 | Implement **Photo Attachment** for tickets (complaint evidence); upload via `/api/uploads` | 🟠 Should |
| TR-03-4 | Implement **Template Selection** dropdown for fast creation from common ticket templates | 🟡 Could |
| TR-03-5 | Display **SLA Countdown Visual Indicator** on ticket list and detail: Green (>50% time left), Yellow (20-50%), Red (<20% or breached), Blinking Red (escalated + breached) | 🔴 Must |
| TR-03-6 | Sort ticket list by **priority + SLA due time** by default | 🔴 Must |
| TR-03-7 | Handle push notification deep-links for: ticket assigned, SLA approaching (30 min warning), SLA breached, escalation, status change - navigate to `tadawi://tickets/{id}` | 🔴 Must |
| TR-03-8 | Load configuration dropdowns (sources, types, classifications, priorities) from cached responses; refresh on app open | 🔴 Must |

### Configuration Endpoints (Mobile)

```
GET /api/ticket-sources
GET /api/ticket-types
GET /api/ticket-classifications
GET /api/ticket-priorities
GET /api/patients/lookup?fileNumber={id}
GET /api/patients/search?query={name}
POST /api/tickets/{id}/escalate
GET /api/tickets/{id}/activities
```

---

## TR-04 - Marketing Module (Mobile Features)

**Source:** BRD §5.5

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-04-1 | Implement **Campaign Dashboard** with four status-count widgets: Draft, Pending, Approved, Launched - fetched from `GET /api/campaign` with status filter | 🟠 Should |
| TR-04-2 | Implement **Workflow Pending** widget - show campaigns awaiting the current user's approval | 🟠 Should |
| TR-04-3 | Implement **Budget Summary** widget - display total budget vs. actual spend per campaign | 🟡 Could |
| TR-04-4 | Implement **Quick Submit** action - submit draft campaign directly from the list (swipe action or contextual menu) | 🟠 Should |
| TR-04-5 | Implement **Quick Approve** action - approve campaign step directly from a push notification or inline action | 🟠 Should |
| TR-04-6 | Implement **View Leads** - one-tap shortcut from campaign to its leads list (`GET /api/campaignlead?campaignCode={code}`) | 🔴 Must |
| TR-04-7 | Implement **Duplicate Campaign** - copy an existing campaign as a new draft | 🟡 Could |
| TR-04-8 | **Offline - Cache** recently viewed campaigns and leads locally (retain 7 days) | 🟠 Should |
| TR-04-9 | **Offline - Queue** new draft campaign creation for sync; queue workflow actions (submit, approve) for sync | 🟠 Should |
| TR-04-10 | Parse API responses through the standard `ApiResponse<T>` wrapper (`success`, `data`, `message`, `errors`, `pagination`) | 🔴 Must |

---

## TR-05 - Push Notifications

**Source:** BRD §6.1

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-05-1 | Integrate **APNs** (iOS) and **FCM** (Android) for push notification delivery | 🔴 Must |
| TR-05-2 | Register device push token with backend on login; de-register on logout | 🔴 Must |
| TR-05-3 | Handle notification **deep links** - parse `data.deepLink` (e.g., `tadawi://tasks/{id}`) and navigate to the correct screen | 🔴 Must |
| TR-05-4 | Handle the following **notification categories** with proper routing: | |
| | • `task.assigned` → Task Detail | 🔴 Must |
| | • `task.due_soon` → Task Detail | 🟠 Should |
| | • `task.overdue` → Task Detail (critical) | 🔴 Must |
| | • `ticket.assigned` → Ticket Detail | 🔴 Must |
| | • `ticket.sla_warning` → Ticket Detail | 🔴 Must |
| | • `ticket.sla_breach` → Ticket Detail (critical) | 🔴 Must |
| | • `ticket.escalated` → Ticket Detail | 🟠 Should |
| | • `marketing.lead.new` → Campaign Leads | 🟡 Could |
| | • `marketing.campaign.alert` → Campaign Detail | 🟡 Could |
| | • `system.announcement` → In-app notification center | 🟡 Could |
| TR-05-5 | Show **badge count** on app icon for unread/unresolved notifications | 🟠 Should |
| TR-05-6 | Support **background notification handling** (silent push) to pre-fetch data when the app is backgrounded | 🟡 Could |

### Notification Payload Contract

```json
{
  "notification": { "title": "...", "body": "...", "sound": "default", "badge": 1 },
  "data": {
    "type": "task.assigned",
    "entityId": "{guid}",
    "deepLink": "tadawi://tasks/{id}",
    "tenantId": "{guid}"
  }
}
```

---

## TR-06 - Offline Capability & Sync

**Source:** BRD §6.2

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-06-1 | Implement **Optimistic UI** - apply changes to local state immediately and sync in background | 🟠 Should |
| TR-06-2 | Implement **Offline Queue** - store pending API actions (create/update) in encrypted local DB; retry queue on network restore | 🟠 Should |
| TR-06-3 | Implement **Conflict Resolution** - server-wins strategy; on sync conflict, notify user with a dismissible banner | 🟠 Should |
| TR-06-4 | Implement **Delta Sync** (future) using planned `GET /api/sync/check` and `POST /api/sync/tasks` / `POST /api/sync/tickets` endpoints | 🟡 Could |
| TR-06-5 | Enforce **local data limits** and retention: | |
| | • Tasks: 200 records, 7-day retention | 🟠 Should |
| | • Tickets: 100 records, 7-day retention | 🟠 Should |
| | • Leads: 100 records, 7-day retention | 🟡 Could |
| | • Attachments: 50 MB total, LRU eviction | 🟠 Should |
| TR-06-6 | Show **offline mode indicator** (banner/icon) when the device has no network connectivity | 🔴 Must |
| TR-06-7 | All locally cached data must be encrypted with **AES-256-GCM** using keys stored in Keychain/Keystore | 🔴 Must |

---

## TR-07 - File Uploads (Mobile)

**Source:** BRD §6.3

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-07-1 | Enforce **pre-upload validation**: file type whitelist (jpg, jpeg, png, gif, pdf, doc, docx, mp3, m4a, wav, mp4, mov) and size limits (images 10MB, docs 25MB, audio 50MB, video 100MB) | 🔴 Must |
| TR-07-2 | **Compress images/videos** before upload to reduce bandwidth usage | 🟠 Should |
| TR-07-3 | Use **chunked upload** via `POST /api/uploads/chunk` for files > 5MB | 🟠 Should |
| TR-07-4 | Support **background upload** - continue upload even when the app is backgrounded (iOS Background Tasks / Android WorkManager) | 🟠 Should |
| TR-07-5 | Support **upload resume** - track uploaded byte offset; resume from last chunk on failure | 🟡 Could |
| TR-07-6 | Confirm upload via `POST /api/uploads/complete` after all chunks are delivered | 🔴 Must |
| TR-07-7 | Show **upload progress indicator** (per-file progress bar) in the UI | 🟠 Should |

### Upload API

```
POST /api/uploads/presigned   - get pre-signed upload URL
POST /api/uploads/chunk       - upload individual chunks
POST /api/uploads/complete    - confirm completion
```

---

## TR-08 - Search & Filtering (Mobile)

**Source:** BRD §6.4

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-08-1 | Implement **Global Search** across Tasks (subject, description, assignee), Tickets (number, patient name, description), and Leads (name, email, phone) | 🟠 Should |
| TR-08-2 | **Debounce** search input by 300ms before triggering API calls to prevent over-fetching | 🔴 Must |
| TR-08-3 | Implement per-module **filter panels**: | |
| | • Tasks: status, priority, assignee, date range, department | 🟠 Should |
| | • Tickets: status, source, type, classification, SLA status, date range | 🟠 Should |
| | • Leads: status, source, score range, assigned-to, date range | 🟡 Could |
| TR-08-4 | Persist active filters across navigation (cleared only on explicit reset) | 🟡 Could |

---

## TR-09 - Localization & RTL Support

**Source:** BRD §6.5

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-09-1 | Support **English** (`en`) and **Arabic** (`ar`) as primary languages; set `Accept-Language` header on all API requests | 🔴 Must |
| TR-09-2 | Implement full **RTL layout mirroring** for Arabic - icons, navigation direction, and text alignment | 🔴 Must |
| TR-09-3 | Support **Hijri Calendar** option for date pickers when locale is `ar` | 🟡 Could |
| TR-09-4 | Support **Arabic numeral** display (١٢٣) as an option | 🟡 Could |
| TR-09-5 | Format currency as **SAR** with locale-appropriate formatting | 🟠 Should |
| TR-09-6 | Support 12-hour (AM/PM) and 24-hour time format switching based on locale | 🟠 Should |

---

## TR-10 - Meeting Module (Mobile Features)

**Source:** BRD §8.4, §8.2

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-10-1 | Implement **One-Tap Join Zoom** - detect when meeting start time is ≤5 min away; show "Join Now" button that opens Zoom app via deep link (`zoomus://`) using `zoomMeeting.joinUrl` | 🔴 Must |
| TR-10-2 | Implement **Calendar Integration** - add meeting to device calendar (iOS EventKit / Android CalendarProvider) with title, time, Zoom link in notes | 🟠 Should |
| TR-10-3 | Implement **Share Meeting** - share meeting title, time, and join URL via native share sheet | 🟡 Could |
| TR-10-4 | Implement **Quick Convert (Meeting → Task)** - one-tap to open task conversion sheet; post `POST /api/meetings/{id}/convert-to-task` with selected points/minutes | 🟠 Should |
| TR-10-5 | Implement **Voice Add Point** - use platform STT to add meeting points via voice during a meeting | 🟡 Could |
| TR-10-6 | Schedule **local notifications** for meeting reminders: 15 min before ("starts in 15 min"), 5 min before ("starting soon - tap to join"), at meeting start time | 🔴 Must |
| TR-10-7 | Notify user when a **meeting point is converted to a task** (in-app notification) | 🟡 Could |
| TR-10-8 | **Offline Cache**: cache upcoming meetings locally; allow read-only viewing of meeting details offline | 🟠 Should |
| TR-10-9 | Handle availability check via `GET /api/meetings/availability` before allowing organizer to schedule conflicting slots | 🟠 Should |
| TR-10-10 | Export **meeting minutes as PDF** by opening `GET /api/meetingminutes/{id}/export` in a native PDF viewer/share sheet | 🟡 Could |

---

## TR-11 - Mobile Security Hardening

**Source:** BRD §9

### Technical Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| TR-11-1 | Enforce **TLS 1.3 minimum** for all API connections; reject downgrades | 🔴 Must |
| TR-11-2 | Implement **Certificate Pinning** using public key hash pinning (TrustKit on iOS, OkHttp CertificatePinner on Android) - pin `api.tadawi.com` | 🔴 Must |
| TR-11-3 | Implement **Root / Jailbreak Detection** on app startup; show warning dialog and limit functionality on compromised devices | 🟠 Should |
| TR-11-4 | Implement **Emulator Detection** in production builds; block or limit functionality on emulators | 🟡 Could |
| TR-11-5 | Use **Platform Attestation** (iOS App Attest / Android Play Integrity API) for high-security operations | 🟡 Could |
| TR-11-6 | Encrypt all PII and cached API responses at rest with **AES-256-GCM**; keys in Keystore/Keychain | 🔴 Must |
| TR-11-7 | Apply **Screenshot/Screen Recording Prevention** on sensitive screens (patient data, token screens) - `FLAG_SECURE` (Android), secure text field layer (iOS) | 🟠 Should |
| TR-11-8 | Enable **code obfuscation** in release builds: R8/ProGuard (Android), LLVM bitcode stripping (iOS) | 🟠 Should |
| TR-11-9 | Implement **App Signature Verification** on startup to detect tampered APKs | 🟡 Could |
| TR-11-10 | Detect **USB Debugging / Debugger Attached**; delay or block sensitive operations when detected | 🟡 Could |
| TR-11-11 | Implement **Anti-Replay** guards on sensitive API requests: include nonce + timestamp in `X-Request-Signature` / `X-Request-Timestamp` headers | 🟡 Could |
| TR-11-12 | Log **security-relevant events** (auth success/fail, biometric use, jailbreak detection, PII access) with 1-2 year retention | 🔴 Must |
| TR-11-13 | Remove all PII from crash reports and logs before submission | 🔴 Must |
| TR-11-14 | Validate all user input before API submission: max-length, whitelist character sets, UUID format for IDs, date range validation | 🔴 Must |

---

## Implementation Plan

### Phase 1 - MVP (Weeks 1-6)
>
> Goal: Working authenticated app with full CRUD for all modules; basic UX.

```
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ Phase 1
```

| Sprint | Deliverable | TRs Covered |
|--------|-------------|-------------|
| S1 (W1-W2) | **Auth Foundation** - OAuth 2.0 + PKCE login flow, secure token storage (Keychain/Keystore), token refresh, required headers, logout | TR-01-1,2,3,4,9,10 |
| S2 (W3-W4) | **Tasks Core** - task list (field-filtered), task detail, status workflow actions (start/complete/fail/defer), push notification deep-link handling for tasks; offline indicator | TR-02-1,2,12; TR-05-1,2,3,4; TR-06-6 |
| S3 (W5) | **Ticketing Core** - ticket list (sorted by priority+SLA), SLA visual indicator, ticket detail, status updates, patient lookup; push notifications for tickets | TR-03-5,6,7,8 |
| S4 (W6) | **Marketing Core** - campaign list, campaign detail, workflow actions (submit/approve/reject/launch), leads list | TR-04-6,10 |
| S4 (W6) | **Meeting Core** - meeting list, meeting detail, one-tap Zoom join, local meeting reminders | TR-10-1,6 |

---

### Phase 2 - Enhancement (Weeks 7-12)
>
> Goal: Mobile-specific UX polish, offline support, file uploads, search.

```
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ Phase 2
```

| Sprint | Deliverable | TRs Covered |
|--------|-------------|-------------|
| S5 (W7-W8) | **Quick Actions** - Progress Slider, Quick Complete, Photo Attachment (Tasks); Barcode Scanner, Photo Attachment (Tickets); Quick Submit/Approve (Marketing) | TR-02-3,4,6; TR-03-1,3; TR-04-4,5 |
| S6 (W9) | **Offline Queue & Caching** - local DB with AES-256-GCM encryption, offline create/update queue, sync on reconnect, conflict resolution banner | TR-06-1,2,3,5,7; TR-02-9,10,11; TR-04-8,9; TR-10-8 |
| S7 (W10) | **File Upload (Mobile)** - pre-upload validation, image compression, chunked upload, background upload, progress indicator | TR-07-1,2,3,4,6,7 |
| S8 (W11) | **Search & Filtering** - debounced global search, per-module filter panels (Tasks + Tickets) | TR-08-1,2,3 |
| S9 (W12) | **Localization (RTL + Arabic)** - full RTL layout, Arabic strings, SAR currency format, 12/24h time | TR-09-1,2,5,6 |

---

### Phase 3 - Hardening (Weeks 13-16)
>
> Goal: Security hardening, advanced features, compliance.

```
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ Phase 3
```

| Sprint | Deliverable | TRs Covered |
|--------|-------------|-------------|
| S10 (W13-W14) | **Security Hardening** - TLS 1.3 enforcement, certificate pinning, root/jailbreak detection, screenshot prevention, code obfuscation, AES-256-GCM cache encryption, security audit logging | TR-11-1,2,3,6,7,8,12,13,14 |
| S11 (W15) | **Biometric Auth & Session Timeout** - Face ID/Fingerprint gate, auto-lock, idle/absolute timeout, 3-device session limit | TR-01-5,6,7,8; TR-11-12 |
| S12 (W16) | **Advanced Features** - Voice Note (Tasks), Calendar Integration (Meetings), Meeting→Task conversion, Meeting Minutes PDF export, Hijri calendar, Dashboard analytics widgets | TR-02-5,7,8; TR-04-1,2,3; TR-09-3,4; TR-10-2,4,10 |

---

## Priority Legend

| Symbol | Meaning | MoSCoW |
|--------|---------|--------|
| 🔴 Must | Non-negotiable for launch | Must Have |
| 🟠 Should | Strong business value, plan for Phase 2 | Should Have |
| 🟡 Could | Nice-to-have, Phase 3 or backlog | Could Have |

---

*Document generated: 2026-03-14 | Source: mobile-api-brd.md v1.3.0*

