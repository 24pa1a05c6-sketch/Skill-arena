# Phase 7 — Guild Architecture Specification

## Guild System Overview
Guilds are competitive software developer squads in Skill Arena that aggregate XP, compete in Guild Leaderboards, and enter team-based arena tournaments.

---

## 1. Guild Hierarchy & Roles
- **LEADER**: Guild creator. Full administrative controls (edit description, invite, promote, kick, delete guild).
- **OFFICER**: Moderation capabilities (accept requests, invite players, manage guild events).
- **MEMBER**: Standard competitive participant (contributes XP, enters guild tournaments, chats in Guild Hall).

---

## 2. Guild Leveling Formulation
Guild Level ($L$) is derived from aggregate member XP:
\[L = \lfloor \sqrt{\text{Total Guild XP} / 1000} \rfloor + 1\]

### Guild Perks & Unlockables:
- **Level 1**: Max 20 members, Guild Hall Chat.
- **Level 5**: Max 50 members, Custom Guild Banner & Tag.
- **Level 10**: Max 100 members, Custom Tournament Hosting privileges.
