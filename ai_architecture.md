# Phase 6 — AI Mentor, Skill Intelligence & Career Engine Architecture

## Overview
This document specifies the enterprise architecture for the Phase 6 AI Platform of Skill Arena.

---

## 1. Provider-Agnostic AI Pipeline Architecture

```
                 ┌─────────────────────────────────────────┐
                 │          AiMentorChatSheet (UI)         │
                 └────────────────────┬────────────────────┘
                                      │
                                      ▼
                 ┌─────────────────────────────────────────┐
                 │           AiEngineNotifier              │
                 │      (Riverpod State Management)        │
                 └────────────────────┬────────────────────┘
                                      │
                                      ▼
                 ┌─────────────────────────────────────────┐
                 │          AiEngineRepository             │
                 └────────────────────┬────────────────────┘
                                      │
                                      ▼
                 ┌─────────────────────────────────────────┐
                 │            PromptSanitizer              │
                 │   (Injection Guard & Rate Limiter)      │
                 └────────────────────┬────────────────────┘
                                      │
                                      ▼
                 ┌─────────────────────────────────────────┐
                 │           AiServiceContract             │
                 │     (Provider-Agnostic Abstraction)     │
                 └──────┬──────────────┬─────────────┬─────┘
                        │              │             │
              ┌─────────┴────┐  ┌──────┴──────┐  ┌───┴─────────────┐
              │ GoogleGemini │  │ OpenAI GPT4 │  │ Claude / Local  │
              └──────────────┘  └─────────────┘  └─────────────────┘
```

---

## 2. AI Intelligence Modules
1. **AI Mentor Profile & Persona**: Persistent persona (AURA) tracking user growth history, focus areas, and skill velocity.
2. **Skill Gap Analysis**: Evaluates completed modules, win rates, and radar scores to identify strengths, weaknesses, and priority actions.
3. **Personalized Learning Engine**: Contextual course and tournament recommendations based on level and skill gap analysis.
4. **Career Roadmap Generator**: Milestone-based roadmaps for 7 career paths (Flutter, Full Stack, AI, Cyber, Cloud, Data Science, DevOps).
5. **AI Code Review**: Automated code quality scoring, time/space complexity analysis ($O(N)$, $O(1)$), and optimization hints.
6. **Mock Interview Simulation**: Interactive technical and behavioral interview preparation with sample answers and AI feedback.
7. **Skill Forecast**: Predicts next badge, estimated win rate, and projected XP growth.
