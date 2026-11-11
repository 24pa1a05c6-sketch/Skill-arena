# Phase 8 — The Vault Marketplace Engine Specification

## Overview
The Vault is Skill Arena's digital store front for SADL glass skins, animated avatar frames, sound packs, and Arena passes.

---

## 1. Asset Purchase Lifecycle
1. User browses Marketplace catalog (`VaultMarketplaceScreen`).
2. App checks `$ARENA` token balance.
3. Transaction recorded in Firestore `transactions` and `owned_items` collections.
4. Item marked as `isOwned: true` and added to user inventory.
