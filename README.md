# 🚀 Kidme Mobile App
**Connecting Talent with Opportunity in Chad.**

Kidme is a premium Flutter mobile application designed to bridge the gap between job seekers and recruiters in Chad. By integrating deeply with the existing Supabase ecosystem and focusing on local recruitment standards (ONAPE), Kidme provides a seamless, trusted, and efficient recruitment workflow for candidates, NGOs, and corporations alike.

---

## ✨ Project Vision
The mission of Kidme is to modernize the Chadian labor market by providing a mobile-first experience that prioritizes verified profiles, clear communication, and professional design.

### 🌟 Key Features
*   **Verified Profiles:** Candidates build "ONAPE-ready" digital identities with document verification (CVs, Diplomas, National ID).
*   **Smart Discovery:** Search for opportunities by category, city, organization type, and remote availability.
*   **Recruitment Dashboard:** A dedicated space for recruiters to manage shortlists, review applications, and track hiring statistics.
*   **Real-time Alerts:** Push notifications for job matches, application status updates, and direct messaging.
*   **Secure Storage:** Fully encrypted storage for sensitive documents using Supabase Storage.

---

## 🛠 Tech Stack
*   **Frontend:** [Flutter](https://flutter.dev/) (Cross-platform performance & Beautiful UI)
*   **Backend:** [Supabase](https://supabase.com/)
    *   **Auth:** Shared cross-platform user accounts.
    *   **Database:** PostgreSQL with Row Level Security (RLS) for data integrity.
    *   **Storage:** Secure bucket for profile media and PDFs.
    *   **Functions:** Edge Functions for server-side logic and audit logs.

---

## 🎨 Design Philosophy
Inspired by leaders like **Apple**, **Stripe**, and **Linear**, Kidme follows a "Professional-Clean" aesthetic:
- **Primary Navy:** `#0A2540` — *Trust & Authority*
- **Professional Blue:** `#2563EB` — *Innovation*
- **Gold Accent:** `#F4B400` — *Excellence*
- **Visuals:** Soft cards, subtle shadows, rounded controls, and fluid motion.

---

## 📂 Project Structure
Kidme uses a feature-first architecture for high scalability and maintainability:
```text
lib/
├── core/           # Constants, global helpers, routing
├── features/       # Modular features (Auth, Jobs, Profile, etc.)
├── theme/          # App-wide styles and design system
├── widgets/        # Reusable UI components
└── main.dart       # App entry point & initialization
```

---

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Supabase Project URL & Anon Key

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

### Quality Control
Before opening a pull request, please run:
```bash
dart format lib test
flutter analyze
flutter test
```

---

## 👥 Roles & Governance
- **Super Admin:** Platform governance, billing, and global audit logs.
- **Organization Admin:** Talent acquisition management for companies and NGOs.
- **Candidate:** Profile management and job application lifecycle.

---

## 🗺 Roadmap
- [x] UI Prototype & Design Foundation
- [x] Supabase Integration (Auth & DB)
- [ ] Document Upload & Profile Verification
- [ ] Real-time Chat & Notifications
- [ ] Recruiter Analytics Dashboard

---

*Developed with ❤️ for the Chadian professional ecosystem.*
