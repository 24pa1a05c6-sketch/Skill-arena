# Phase 10 — AI Proctoring Security Architecture Specification

## Overview
Ensures test integrity during high-stakes competitive coding tournaments and recruiter skill verifications.

---

## 1. Proctoring Violation Types
- `tabSwitch`: User switching browser tabs or desktop apps.
- `copyPaste`: Unsanitized external clipboard paste events.
- `multipleMonitors`: Dual screen focus detection.
- `faceMissing`: Neural webcam face presence loss.
- `screenBlur`: Window focus loss.

---

## 2. Violation Escalation & Audit Trail
Proctoring warnings update in real-time on `LiveCodingArenaScreen` app bar badge and log directly into Firestore `proctor_logs`.
