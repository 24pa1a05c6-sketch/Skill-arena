# Skill Arena — Enterprise Firestore Database Schema (2030 Edition)

## Overview
This document specifies the authoritative production Firestore schema across all 11 enterprise collections for Skill Arena.

---

## Collections Specification

### 1. `users`
- **Document ID**: `{userId}` (Firebase Auth UID)
- **Fields**:
  - `name`: `string`
  - `email`: `string`
  - `avatarUrl`: `string`
  - `handle`: `string` (`@handle`)
  - `rankTitle`: `string`
  - `level`: `number` (integer)
  - `xp`: `number` (integer)
  - `arenaTokens`: `number` (integer)
  - `isGuest`: `boolean`
  - `updatedAt`: `timestamp`

### 2. `tournaments`
- **Document ID**: `{tournamentId}`
- **Fields**:
  - `title`: `string`
  - `category`: `string` (e.g. `Cybersecurity`, `Flutter`, `AI`, `Web3`)
  - `difficulty`: `string` (`Easy`, `Medium`, `Hard`, `Expert`)
  - `prizeTokens`: `number` (integer)
  - `participantCount`: `number` (integer)
  - `maxParticipants`: `number` (integer)
  - `startTime`: `timestamp`
  - `status`: `string` (`upcoming`, `live`, `completed`)
  - `bracketRounds`: `array<string>`

### 3. `courses`
- **Document ID**: `{courseId}`
- **Fields**:
  - `title`: `string`
  - `category`: `string` (`FLUTTER`, `CYBER`, `AI`, `WEB3`)
  - `level`: `string`
  - `progress`: `number` (double, `0.0` - `1.0`)
  - `totalModules`: `number` (integer)
  - `completedModules`: `number` (integer)
  - `xpReward`: `number` (integer)

### 4. `registrations`
- **Document ID**: `{tournamentId}_{userId}`
- **Fields**:
  - `tournamentId`: `string`
  - `userId`: `string`
  - `registeredAt`: `timestamp`
  - `status`: `string` (`confirmed`, `checked_in`, `disqualified`)

### 5. `badges`
- **Document ID**: `{badgeId}`
- **Fields**:
  - `name`: `string`
  - `description`: `string`
  - `iconUrl`: `string`
  - `unlockedAt`: `timestamp`

### 6. `notifications`
- **Document ID**: `{notificationId}`
- **Fields**:
  - `userId`: `string`
  - `title`: `string`
  - `body`: `string`
  - `type`: `string` (`tournament_reminder`, `match_found`, `xp_earned`, `badge_unlocked`)
  - `read`: `boolean`
  - `createdAt`: `timestamp`

### 7. `leaderboards`
- **Document ID**: `{entryDocId}`
- **Fields**:
  - `userId`: `string`
  - `name`: `string`
  - `rank`: `number` (integer)
  - `earnings`: `number` (integer)
  - `avatarUrl`: `string`

### 8. `xp_logs`
- **Document ID**: `{logId}`
- **Fields**:
  - `userId`: `string`
  - `xpAmount`: `number` (integer)
  - `source`: `string` (`course_module`, `tournament_win`, `daily_streak`)
  - `timestamp`: `timestamp`

### 9. `wallet`
- **Document ID**: `{userId}`
- **Fields**:
  - `arenaTokens`: `number` (integer)
  - `stakedTokens`: `number` (integer)
  - `transactions`: `array<map>`
  - `updatedAt`: `timestamp`

### 10. `skills`
- **Document ID**: `{userId}`
- **Fields**:
  - `skills`: `map<string, double>` (e.g. `Code: 0.90, Design: 0.85, Strategy: 0.80, Sec: 0.88, Speed: 0.92`)
  - `updatedAt`: `timestamp`

### 11. `analytics_events`
- **Document ID**: `{eventId}`
- **Fields**:
  - `userId`: `string`
  - `eventName`: `string`
  - `parameters`: `map`
  - `timestamp`: `timestamp`
