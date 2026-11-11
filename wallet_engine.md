# Phase 8 — ARENA Wallet Engine Specification

## Overview
Manages balance updates, token credits/debits, referral payouts, and transaction logging.

---

## 1. Wallet Data Model
- `tokenBalance`: Current `$ARENA` tokens.
- `xpBalance`: Total accumulated XP.
- `coins`: Arena Coins balance.
- `referralBonus`: Bonus credits earned from invited friends.
- `transactions`: Immutable audit log of all financial events.
