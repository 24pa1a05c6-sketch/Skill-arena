# Phase 5 — Tournament & Competition Engine Architecture

## Overview
This document specifies the enterprise architecture for Phase 5 Tournament & Competition Engine of Skill Arena.

---

## 1. System Architecture Diagram

```
                       ┌─────────────────────────────────────┐
                       │        BattleGridScreen (UI)        │
                       │   (SkillBracketViewer, SADL Cards)   │
                       └──────────────────┬──────────────────┘
                                          │
                                          ▼
                       ┌─────────────────────────────────────┐
                       │      TournamentEngineNotifier       │
                       │          (Riverpod State)           │
                       └──────────────────┬──────────────────┘
                                          │
                                          ▼
                       ┌─────────────────────────────────────┐
                       │     TournamentEngineRepository      │
                       └─────────┬─────────────────┬─────────┘
                                 │                 │
             ┌───────────────────┴─┐             ┌─┴───────────────────┐
             │ MatchmakingService  │             │   EloRatingService  │
             │   RewardsEngine     │             │  (Bronze -> Legend) │
             └─────────────────────┘             └─────────────────────┘
                                 │                 │
                                 ▼                 ▼
                       ┌─────────────────────────────────────┐
                       │ Firestore & StorageService Fallback │
                       │(matches, brackets, ratings, rewards)│
                       └─────────────────────────────────────┘
```

---

## 2. Tournament Lifecycle States
1. `draft`: Created by organizer; invisible to public.
2. `scheduled`: Publicly visible; registration opens at designated timestamp.
3. `registrationOpen`: Open for user registrations & fee check.
4. `registrationClosed`: Registration locked; seeds finalized.
5. `live`: Active matches in progress.
6. `roundComplete`: Current round concluded; winners advancing.
7. `semiFinals`: Top 4 competitors remaining.
8. `finals`: Championship match active.
9. `completed`: Champion crowned; rewards distributed.
10. `archived`: Read-only historical record.
11. `cancelled`: Refunded entry fees & logged.

---

## 3. ELO / Skill Rating Algorithm
Match rating updates follow standard ELO formulation:
\[E_A = \frac{1}{1 + 10^{(R_B - R_A)/400}}\]
\[R'_A = R_A + K \times (S_A - E_A)\]

### Competitive Rank Tiers:
- **BRONZE**: ELO < 1200
- **SILVER**: 1200 - 1399
- **GOLD**: 1400 - 1599
- **PLATINUM**: 1600 - 1799
- **DIAMOND**: 1800 - 1999
- **MASTER**: 2000 - 2199
- **GRANDMASTER**: 2200 - 2399
- **LEGEND**: ELO ≥ 2400
