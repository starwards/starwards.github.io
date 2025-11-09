# Questions for Blog Post Series

These questions need answers to ensure factual accuracy and proper context for the blog catch-up series.

## Timeline and Major Events

### The "Rewrite" (March 2024)
**Current understanding:** March 2024 wasn't a "rewrite from scratch" but rather a focused effort to reach LARP-playable product.

**Questions:**
1. What specifically happened in March 2024? Was it:
   - A restructuring/refactoring of existing code?
   - A shift in development priorities/focus?
   - Removing scope creep to focus on core features?
   - Something else?

2. What changed about the development approach at that time?

3. Was there any actual "starting over" or was it more "getting back on track"?

4. What PRs or commits mark this transition? (so I can look at what actually changed)

---

### 3D Rendering Removal

**Current understanding:**
- 3D was for feature parity and wow effect
- Important for immersion but not as critical as informative UI
- Reasons for removal: (1) focus effort on critical stuff including assets pipeline, (2) Unity POC with Colyseus polyglot means main screen can be different client

**Questions:**
1. When was the Unity + Colyseus POC built? Before or after removing the 3D code?

2. Is the Unity client still being developed or is it on hold?

3. What's the plan for the main screen going forward? Will it be:
   - Unity-based 3D client?
   - Different technology?
   - Still TBD?

4. Should the blog post present the 3D removal as:
   - "We're not doing 3D in the main client, we'll do it as a separate Unity client later"?
   - "We're deferring 3D until core features are done"?
   - Something else?

---

## Technical Systems

### Energy/Heat/Coolant System
**Questions:**
1. When were these systems actually implemented? (year/month roughly)

2. Were they part of the 2021-2022 prototype or only in the 2024 work?

3. Any specific PRs or commits I should reference?

---

### Missiles and Torpedoes
**Questions:**
1. When were missiles implemented?

2. Were they in the original prototype or only recent?

3. Any specific PRs to reference?

---

### Armor System
**Current understanding:** PRs #1696 and #1733 fixed armor bugs in April 2024

**Questions:**
1. When was the armor system first implemented (even if buggy)?

2. Was the basic armor concept working before April 2024, just with calculation bugs?

3. Is the Battletech inspiration still accurate to mention?

---

### Bot AI and Autopilot
**Current understanding:** The "spiral bug" was from June 2022 post

**Questions:**
1. When did the smart pilot system get implemented?

2. When did the bot orders system (MOVE, ATTACK, FOLLOW) get implemented?

3. PR #1640 (March 2024) - is this when bot AI was added, or is that PR about something else?

---

### Warp, Waypoints, Docking
**Current understanding:** PR #1753 (May 2024) added waypoints

**Questions:**
1. When were warp drives implemented?

2. When was docking implemented?

3. Were these all 2024 additions or were some in the earlier prototype?

---

## Development History

### 2021-2022 Prototype
**Questions:**
1. What major systems were in the 2021-2022 version? (so I know what was actually "carried forward")

2. What was the state of the project in June 2022 when the blog went silent?

3. Why did development slow down / blog go silent? Was it:
   - Feeling stuck on technical problems?
   - Uncertainty about direction?
   - Life/work getting in the way?
   - Something else?

---

### Memory Leaks and Technical Debt
**Current understanding:** PR #1680 (March 2024) fixed memory leaks

**Questions:**
1. Were there specific incidents that prompted the memory leak fixes? (server crashes, degrading performance?)

2. Was this part of the "March 2024 focus" or unrelated?

---

## Documentation and Testing

### Documentation Effort
**Questions:**
1. When were the major docs files (ARCHITECTURE.md, SUBSYSTEMS.md, etc.) written?

2. Was this part of the March 2024 work or spread over time?

3. Who wrote most of the documentation? (team effort or one person's initiative?)

---

### Testing Infrastructure
**Questions:**
1. When was Playwright testing added?

2. When were the test harnesses built?

3. Was testing part of the "focus on LARP-playable product" effort?

---

## Current State and Future

### What's Actually Playable Now (Nov 2024)?
**Questions:**
1. Can you actually run a LARP event with Starwards today? Or is it "almost there"?

2. What's the biggest blocker to running a real event?

3. Has anyone outside the dev team playtested it?

---

### What's Actually Missing?
**Current understanding from BLOG_CATCH_UP_PLAN.md:**
- Corvette-class ships
- Multiple bridges
- Advanced damage reports
- Cyber warfare
- Point defense / CIWS

**Questions:**
1. Are there other critical missing features not listed in the plan?

2. What's the #1 priority for next development phase?

3. Is the roadmap in the plan accurate to your thinking?

---

## Open Source and Community

### GitHub and Community
**Questions:**
1. When did the repository become public?

2. Have there been any external contributors? Even small PRs?

3. Is there an active Discord? How many members?

4. What's the realistic expectation for community contributions?

---

## Blog Series Meta

### Goals for the Series
**Questions:**
1. Primary goal: Re-engage dormant audience, attract new contributors, or both?

2. Target audience: Technical game devs, LARP organizers, general open-source enthusiasts?

3. Tone: Apologetic for silence, matter-of-fact about work done, excited about future? Mix?

---

### Publication Plan
**Questions:**
1. Do you want to edit these before publishing or publish as-is after fixes?

2. Should I include placeholder sections like "[SCREENSHOT: armor widget]" where visuals would go?

3. Any posts you want to skip from the series?

4. Any posts you want to add that aren't in the current 10-post plan?

---

## Fact-Checking Specific Claims

Please mark TRUE/FALSE/CLARIFY for each:

1. **Claim:** "Starwards is more complete than it's ever been as of November 2024"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

2. **Claim:** "The rewrite took eight months (March-November 2024)"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

3. **Claim:** "We have comprehensive testing infrastructure with Playwright E2E tests"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

4. **Claim:** "We have Node-RED integration for external scripting"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

5. **Claim:** "The 3D code was deleted in PR #1659"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

6. **Claim:** "All ship systems use the effectiveness formula: `effectiveness = power × coolantFactor × (1 - hacked)`"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

7. **Claim:** "Missiles have 720°/s rotation capacity and 100m proximity detonation"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

8. **Claim:** "The last blog post was June 19, 2022"
   - [ ] TRUE  [ ] FALSE  [ ] CLARIFY: _______

---

## Additional Context

**Any other context I should know that would help write these posts accurately?**

(Space for freeform answers)
