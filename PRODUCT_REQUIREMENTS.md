# Kidme Product Requirements

## Vision

Kidme connects job seekers in Chad with trusted recruiters from companies, NGOs, and institutions. The platform should reduce application friction for candidates while giving recruiters clean, structured, compliant candidate data.

## MVP Scope

1. Authentication
   - Candidate account creation with email and password.
   - Organization admin login using accounts created by a Super Admin.
   - Role-aware access control.

2. Candidate Profile
   - First name and last name.
   - Email address.
   - Date and place of birth.
   - Nationality.
   - National Identity Number.
   - Marital status.
   - Diploma level: BEPC/BEF, Baccalaureate, BTS, DEUG, License, Master, PhD.
   - Cover letter generator using candidate name and email.
   - Diploma PDF upload.
   - National ID PDF upload.
   - Criminal record PDF upload dated less than 6 months.
   - Optional profile photo.

3. Job Discovery
   - List jobs by category, organization, location, contract type, salary range, and remote availability.
   - Save jobs.
   - Apply to jobs.
   - Track application status.

4. Recruiter Tools
   - Create and publish job postings.
   - Edit postings within 2 hours after publication.
   - View applicants for own organization only.
   - Filter applicants by profile completeness, diploma, city, and status.
   - Shortlist, reject, invite to interview, and mark hired.

5. Super Admin Tools
   - Create/delete organization admins.
   - Manage organizations, subscriptions, publication categories, rules, and audit logs.
   - Delete organization or candidate accounts when required.

## Later Phases

- Recruiter-candidate chat.
- Push notifications.
- Candidate video introductions.
- Job post comments and reactions.
- Advanced matching score.
- Reporting dashboards.
- Billing and subscription automation.
- AI-assisted candidate summaries.

## Data Model Draft

- profiles
- organizations
- organization_members
- jobs
- job_categories
- applications
- documents
- subscriptions
- messages
- notifications
- audit_logs

## Security Notes

- Store sensitive documents in private buckets.
- Use signed URLs for temporary file access.
- Use Row Level Security for every table.
- Never let clients write audit logs directly.
- Keep Super Admin operations behind server-side functions.
- Avoid exposing candidate identity documents to recruiters unless required for a specific hiring stage.

## UX Principles

- Ask for minimum data at signup, then progressively complete the profile.
- Make document upload feel like a checklist, not a long form.
- Show application status clearly.
- Use verified recruiter signals to build trust.
- Keep recruiter screens dense, scannable, and calm.
