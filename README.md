# Kidme Mobile App

Kidme is a Flutter mobile app for job seekers and recruiters in Chad. It helps candidates build a trusted, ONAPE-ready profile and helps companies, NGOs, and institutions publish opportunities, review applicants, and manage recruitment workflows.

## Product Direction

The first mobile release should stay focused and excellent:

- Candidate onboarding with email/password authentication.
- Job discovery by category, city, organization type, and remote availability.
- Candidate profile with identity, education, documents, profile photo, and cover letter.
- Job application flow with status tracking.
- Recruiter-facing preview for applicants, shortlists, and offer statistics.
- Notifications for job alerts, messages, and application updates.

Advanced social features such as public comments, likes, candidate-to-candidate chat, videos, and broad recruiter analytics should be phased in after the core hiring workflow is stable.

## Backend Recommendation

Because the existing web app uses Supabase, the mobile app should use Supabase first for the shared production data layer:

- Supabase Auth for shared user accounts.
- Postgres tables for jobs, organizations, subscriptions, profiles, applications, and audits.
- Supabase Storage for CVs, diplomas, national ID PDFs, criminal records, profile photos, and profile media.
- Row Level Security policies for Super Admin, Admin, Recruiter, and Candidate permissions.
- Supabase Edge Functions for privileged actions, audit logs, and notification triggers.

Avoid mixing Firebase Firestore and Supabase for the same core data at the start. It adds synchronization, duplicate security rules, and data ownership complexity. Firebase can still be added later only for a narrow reason, such as FCM push notifications, if Supabase push/edge workflows do not cover the mobile needs.

## Roles

- Super Admin: owns the platform, creates admin accounts, manages global rules, billing, contracts, account deletion, and audit visibility.
- Organization Admin: represents a company, NGO, or institution. Manages its jobs, candidates, applicant statistics, and limited post edits.
- Candidate: creates a profile, uploads required documents, applies to jobs, tracks application status, and communicates with recruiters.

## Design System

Kidme should feel premium, modern, clear, and trustworthy. The current prototype uses:

- Primary Navy: `#0A2540`
- Professional Blue: `#2563EB`
- Soft White: `#F8FAFC`
- Gold Accent: `#F4B400`
- Professional Dark Text: `#1E293B`
- Soft Grey: `#94A3B8`

The visual direction is inspired by Apple, Linear, Stripe, LinkedIn, and high-quality recruitment dashboards: soft cards, strong typography, rounded controls, subtle shadows, clear status indicators, and calm motion.

## Development

```bash
flutter pub get
flutter run
```

Run checks before opening a pull request:

```bash
dart format lib test
flutter analyze
flutter test
```

## Suggested Architecture

```text
lib/
  core/              shared constants, routing, helpers
  features/
    auth/
    jobs/
    profile/
    applications/
    recruiter/
    notifications/
  theme/             colors and app theme
  widgets/           shared UI components
```

The current repository contains a first UI prototype and design foundation. The next technical step is to connect it to the same Supabase project as the web app.
