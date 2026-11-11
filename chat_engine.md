# Phase 7 — Real-Time Chat Engine Specification

## Overview
Skill Arena supports real-time multi-channel communication backed by Cloud Firestore and Riverpod streams.

---

## 1. Supported Channels
1. **Private Chat**: One-on-one direct messaging between mutual friends.
2. **Guild Chat**: Real-time channel for active squad members (`guild_chat` collection).
3. **Tournament Chat**: Match-specific channel during active Battle Grid rounds.

---

## 2. Advanced Chat Features
- **Read Receipts**: Tracks user IDs in `readBy` array.
- **Message Reactions**: Emoji reaction counter maps (`🔥`, `🚀`, `👏`).
- **Voice Notes**: Voice note payload structure with storage URL.
