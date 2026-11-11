# Phase 7 — Social & Live Presence Specification

## Overview
Provides social networking capabilities, live presence monitoring, global search, and activity timelines.

---

## 1. Presence Engine States
- `online`: User active in app.
- `offline`: Inactive or disconnected.
- `inMatch`: Competing in active Battle Grid tournament match.
- `learning`: Completing Academy skill tree lesson.
- `away`: Idle for 5+ minutes.
- `dnd`: Do Not Disturb mode.

---

## 2. Global Search Engine
Unified search query parser across 4 entities:
- **Players**: User handles, Rank Tiers, ELO ratings.
- **Guilds**: Guild name, Tag, Level.
- **Courses**: Academy skill trees.
- **Tournaments**: Active and upcoming Battle Grid events.
