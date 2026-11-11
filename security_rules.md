# Skill Arena — Enterprise Firebase Security Rules Specification

## Overview
Security rules for Firestore and Cloud Storage enforce strict authentication, ownership checks, role-based access control, and payload validation.

---

## 1. Firestore Rules Summary (`firestore.rules`)
- **Authentication Guard**: `isAuthenticated()` requires a non-null `request.auth` context.
- **Ownership Guard**: `isOwner(userId)` matches `request.auth.uid == userId`.
- **Role-Based Access**: `isAdmin()` checks `request.auth.token.role == 'admin'`.
- **Read/Write Restrictions**:
  - `users`: Users read any profile; write restricted to owner or admin.
  - `tournaments` & `courses`: Read public; writes restricted to admin.
  - `registrations`: Users create registrations; modifications restricted to admin.
  - `wallet`: Read/write strictly restricted to owner or admin.
  - `analytics_events`: Authenticated users can write event telemetry; read restricted to admin.

---

## 2. Storage Rules Summary (`storage.rules`)
- **Avatars**: Users upload avatar images under `/users/{userId}/avatars/` with max file size `< 5MB`.
- **Certificates**: User portfolio certificates uploaded under `/users/{userId}/certificates/` with max file size `< 10MB`.
- **Courses & Tournaments**: Assets managed exclusively by Admin role.
