# Blog Writing Quick Reference

*Quick lookup guide for writing Starwards blog posts*

---

## Essential Files to Review

1. **BLOG_CATCH_UP_PLAN.md** - Complete series plan, changes inventory
2. **WRITING_STYLE_ANALYSIS.md** - Comprehensive voice and style guide
3. **CLAUDE.md** - Project overview and conventions

---

## The 10-Post Series Overview

| # | Title | Theme | Key Message |
|---|-------|-------|-------------|
| 1 | Letting Go of 3D | Strategic focus | "We chose depth over spectacle" |
| 2 | Engineering Complete | Milestone delivered | "Every system is living and breathing" |
| 3 | Missiles & Torpedoes | Engagement circles | "The three circles are complete" |
| 4 | Armor Reborn | Design to reality | "The design is now real" |
| 5 | Bots & AI | Automation | "Ships can think for themselves" |
| 6 | Navigation Systems | Scale expansion | "The universe just got bigger" |
| 7 | Combat Refinements | Polish | "Combat rewards skill and coordination" |
| 8 | Developer Experience | Community | "Building a platform, not just a game" |
| 9 | The Rewrite | Technical maturity | "Sometimes rebuild the foundation" |
| 10 | State of Starwards 2025 | Future vision | "Join us in building the simulator" |

---

## Voice Checklist

✅ **Use:**
- First-person plural "we"
- Conversational tone
- Parenthetical asides (for clarification)
- Rhetorical questions
- Self-deprecating humor
- Technical depth with explanations
- H2/H3 headers for structure

❌ **Avoid:**
- Marketing/hype language
- First-person singular (unless attributed)
- Hiding challenges/failures
- Assuming technical knowledge
- Excessive bold or ALL CAPS
- Being too brief

---

## Post Structure Template

```markdown
---
layout: post
title: [Post Title]
subtitle: [Subtitle]
tags: [tag1, tag2, tag3]
---

## [Context Header]
[Set the stage, reference past posts]

## [Problem/Topic Header]
[Present the challenge or topic]

## [Analysis/Implementation Header]
[Deep dive into solution/system]

## [Impact/Results Header]
[What it means for LARP/gameplay]

## [Next Steps/Reflection]
[Looking forward or lessons learned]
```

---

## Common Tags

**Primary:** `product`, `design`, `technology`, `game-design`

**Systems:** `weapons`, `damage`, `stations`, `dogfight`

**Specific:** `gm`, `AI`, `art`, `story`

---

## Key Callbacks to Make

### To 2021 Posts
- "The first game design milestone" → Dogfight focus
- "The space fighter dilemma" → Fighter justification
- "Engagement Circles" → Weapon range design
- "Designing a damage system" → Armor/engineering
- "The Epsilon Saga" → Lessons from forking

### To 2022 Posts
- "Starwards is now open-source" → Community commitment
- "Working on simple AI commands" → AI evolution
- "Radar Damage" → The last post

---

## Signature Phrases

Use these to maintain voice authenticity:
- "Easy peasy!"
- "Fork it"
- "Dead simple, right?"
- "After giving it a deep thought..."
- "As we strive to..."
- "We like..." / "We wanted..."
- "So here we are..."
- "That builds the niche aspect..."

---

## Technical Formula Examples

**System Effectiveness:**
```
effectiveness = broken ? 0 : power × coolantFactor × (1 - hacked)
```

**Heat Mechanics:**
```
heat += usageHeat * dt
heat -= (coolantFactor × coolantPerFactor) * dt
if (heat > 100) { broken = true }
```

**Explosion Damage Falloff:**
```
damage = baseDamage × (1 - distance/radius)²
```

---

## Multimedia Integration

**Always include:**
- Screenshots showing features
- Code snippets for technical posts
- Diagrams for complex systems
- Links to GitHub PRs/issues

**Where applicable:**
- GIFs/videos of gameplay
- Comparison tables
- External reference videos (like original posts)

**Bootstrap classes for images:**
- `.mx-auto.d-block` - Center image
- `.float-right` / `.float-left` - Float with text wrap
- `.img-thumbnail` - Add border/padding

---

## Post-Specific Quick Notes

### Post 1: 3D Removal
- PR #1659 (March 2024)
- Deleted entire `modules/browser/src/3d/` directory
- Strategic focus decision
- Reference early 2021 3D experiments

### Post 2: Engineering
- `reactor.ts`, `energy-manager.ts`, `heat-manager.ts`
- Callback to "Moving to the second milestone" (March 2021)
- Formula: `effectiveness = broken ? 0 : power × coolantFactor × (1 - hacked)`
- Educational deep-dive

### Post 3: Missiles
- `tube.ts`, `magazine.ts`, `explosion.ts`
- Three projectile types with comparison table
- Homing: 720°/s rotation, proximity detonation at 100m
- Callback to "Engagement Circles" (Feb 2021)

### Post 4: Armor
- `armor.ts`, `damage-manager.ts`
- PRs #1696, #1733 (fixes)
- Battletech inspiration (as in original post)
- Callback to "Designing a damage system" (April 2021)

### Post 5: AI/Bots
- `automation-manager.ts`, `smart-pilot.ts`
- Orders: MOVE, ATTACK, FOLLOW
- Callback to spiral-bug from "Working on simple AI commands" (June 2022)
- Humor about the bug

### Post 6: Navigation
- `warp.ts`, `waypoint.ts` (PR #1753), `docking.ts`
- Enhanced pilot controls: strafe, antiDrift, breaks
- Scale expansion narrative

### Post 7: Combat Polish
- `targeting.ts`, enhanced `radar.ts`
- Physics improvements (raycast, spatial hashing)
- Callback to "Radar Damage" (June 2022) - the last post!

### Post 8: Developer Experience
- 10+ documentation files
- Testing infrastructure (Playwright, test harnesses)
- Node-RED integration
- Callback to "Starwards is now open-source" (June 2022)

### Post 9: Rewrite
- March 2024 fresh start
- Colyseus architecture (SpaceRoom, ShipRoom)
- Memory leak fixes (PR #1680)
- Callback to "The Epsilon Saga" for parallel journey

### Post 10: Future Vision
- Summarize series
- Roadmap and missing features
- Community call to action
- Link all previous posts

---

## Success Criteria Per Post

Each post should:
- [ ] Explain "why" behind decisions
- [ ] Show journey, not just destination
- [ ] Link to 1-2 relevant past posts
- [ ] Include technical depth
- [ ] Be accessible to non-experts
- [ ] Include visuals/multimedia notes
- [ ] End with implications/next steps
- [ ] Maintain authentic Starwards voice

---

## Last Blog Post Context

**"Radar Damage" (June 19, 2022)**
- Demonstrated radar range flickering when damaged
- 3,000m → 1,500m fluctuation
- Radar sharing mitigation mentioned
- Included .webm video demonstration

This was the LAST post before 2.5 year silence!

---

## File Naming Convention

Format: `YYYY-MM-DD-title.md`

Example: `2025-01-15-letting-go-3d.md`

Place in: `_posts/`

---

## Quick Start for Writing Session

1. Open **BLOG_CATCH_UP_PLAN.md** for detailed post plan
2. Review **WRITING_STYLE_ANALYSIS.md** for voice
3. Check past posts for callback context
4. Draft using structure template above
5. Include multimedia notes (mark with `[TODO: screenshot/video]`)
6. Verify success criteria checklist
7. Add YAML front matter with appropriate tags

---

*This quick reference provides immediate access to essential information for maintaining consistency and authenticity when writing Starwards blog posts.*
