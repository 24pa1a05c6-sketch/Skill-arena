# Skill Arena — Matchmaking Engine Specification

## Supported Formats
1. **Single Elimination**: Binary tree tournament structure ($2^N$ seeds). Loser eliminated immediately.
2. **Double Elimination**: Upper winner bracket & lower loser bracket graph.
3. **Round Robin**: All $N$ players compete against every opponent once ($N(N-1)/2$ matches).
4. **Swiss System**: $R$ rounds matching players with identical scores each round.
5. **League**: Seasonal points table based on Wins (3 pts), Draws (1 pt), Losses (0 pts).

---

## Tournament Bracket Rendering
- `SkillBracketViewer` uses Flutter's `InteractiveViewer` for smooth 2D pan and zoom gestures.
- Round headers highlight active round stages (`ROUND 1`, `SEMI-FINALS`, `FINALS`).
- Live status badges (`LIVE`, `FINAL`, `PENDING`) update dynamically via Riverpod streams.
