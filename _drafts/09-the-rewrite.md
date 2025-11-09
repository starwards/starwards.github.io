---
layout: post
title: "The Rewrite: Why We Started Fresh"
subtitle: Sometimes you need to rebuild the foundation
tags: [technology, product, story]
---

In March 2024, we made a decision that's both liberating and terrifying: we decided to rewrite Starwards from scratch.

Not "refactor some parts." Not "clean up the messy bits." **Rewrite.** Start with an empty repository and rebuild the entire game from the ground up.

If you've worked on software projects for any length of time, you know this is usually a bad idea. The second-system effect. The rewrite trap. The sunk-cost fallacy in reverse.

And yet, we did it anyway.

Why?

## The Prototype: What We Learned (2021-2022)

Let's go back to the beginning. In early 2021, we started building Starwards with a simple goal: prove that a multiplayer LARP bridge simulator could work.

We built:
- A Colyseus server (real-time multiplayer state sync)
- A PixiJS client (2D rendering)
- Basic ship systems (reactor, thrusters, weapons)
- A modular UI (drag-and-drop widgets)
- The dogfight milestone (ships that fly and fight)

And it *worked*. We proved the concept. You could run a ship with multiple players, each at their own station. You could dogfight. You could damage systems. The core vision was validated.

But as we kept building, cracks started showing:

### Problem 1: Architecture Drift

We'd started with a rough architecture: "Colyseus for state, PixiJS for rendering, React for UI."

But we hadn't thought deeply about:
- How state should be structured (monolithic room vs. per-ship rooms?)
- How commands should work (direct method calls vs. message passing?)
- How UI should integrate with state (manual subscriptions everywhere?)

So we made it up as we went. Each new feature added a new pattern. By mid-2022, the codebase had five different ways to update state, three different patterns for UI subscription, and no clear mental model.

It worked, but it was **inconsistent**.

### Problem 2: Technical Debt Accumulation

We were learning Colyseus as we built. We didn't know the gotchas:
- `.toArray()` on a MapSchema creates a memory leak (you need `.values()` instead)
- Nested schemas need careful cleanup or they leak references
- Client-side schema listeners must be explicitly removed or they accumulate

We hit these issues one by one, fixed them individually, but never went back and audited the whole codebase.

[Pull request #1680](https://github.com/starwards/starwards/pull/1680) (March 2024) fixed a bunch of memory leaks, but it was whack-a-mole. We'd fix one leak, find another. The codebase was littered with subtle resource management bugs.

### Problem 3: The 3D Albatross

As we discussed in Post 1, we'd spent months building 3D rendering. And it was *everywhere*. The rendering pipeline assumed 3D might exist. The camera system supported both 2D and 3D. The main screen toggled between modes.

Even after we decided 3D wasn't worth it, the architecture was still shaped by it. Removing 3D wasn't just deleting files—it was untangling assumptions.

### Problem 4: Lack of Testing

The 2021-2022 codebase had minimal tests. Maybe 20% coverage, and most of those tests were brittle (they broke whenever we changed implementation details).

This made refactoring scary. You'd change something, hope it didn't break anything, and only find out when you manually tested.

No CI/CD. No regression tests. No safety net.

### The Realization

By late 2023, we had a working prototype with **years of accumulated cruft**.

And we realized: if we're going to build Starwards for the long term—if we're going to open-source it, invite contributors, and make it maintainable—we need a foundation we can trust.

We couldn't just keep building on top of the prototype. We needed to **start fresh**, armed with everything we'd learned.

## The Decision: Rebuild the Foundation

In March 2024, we started the rewrite with a clear plan:

### 1. Architecture First

Before writing code, we designed the architecture:

**State structure:**
- `SpaceRoom` — Shared space simulation (60 Hz physics, all ships and objects)
- `ShipRoom` — Per-ship state (one room per ship, only that ship's crew sees it)
- `AdminRoom` — Game lifecycle management (lobby, save/load, GM commands)

This is cleaner than the monolithic room we had before. It scales better (you can run 100-ship battles without every client receiving every ship's internal state). It isolates concerns (physics in SpaceRoom, crew coordination in ShipRoom).

**Command pattern:**
- All state changes go through JSON Pointer commands
- `SET /path/to/property value` — Change a value
- Commands are validated, logged, and replay-able

This replaces the "call methods on the state object" pattern, which was hard to debug and impossible to replay.

**Subscription pattern:**
- UI components subscribe to specific paths in the state
- When that path changes, the component re-renders
- Unsubscribe on unmount (no memory leaks)

This is consistent across the entire UI. No more five different patterns.

### 2. Test-Driven (Where It Matters)

We didn't go full TDD (that's impractical for game development), but we committed to:
- Write tests for core systems (energy, heat, damage, physics)
- Write E2E tests for user flows (join game, control ship, fire weapons)
- Run tests in CI (catch regressions before merge)

The test harnesses (from Post 8) were built *during* the rewrite, not after. Testing was first-class.

### 3. No 3D

We committed up front: **2D only**. This simplified everything.

One rendering pipeline. One camera system. One set of visual assets. The codebase is leaner, the cognitive load is lower.

### 4. Documentation as Code

Every system got documented as it was implemented:
- `ARCHITECTURE.md` written alongside the room architecture
- `SUBSYSTEMS.md` written as systems were added
- `PATTERNS.md` written when we established conventions

The documentation isn't an afterthought—it's part of the implementation.

### 5. Carry Forward the Good Parts

We didn't throw away *everything*. We kept:
- The modular widget system (it worked well)
- The PixiJS rendering approach (simple and effective)
- The ship system abstractions (reactor, thrusters, weapons, etc.)
- The core game design (engagement circles, damage system, etc.)

The rewrite was about **rebuilding the foundation**, not reinventing the game.

## The Execution: March-November 2024

The rewrite took eight months. Here's what we built:

**March-April:** Core architecture (rooms, commands, state sync)

**April-May:** Ship systems (reactor, thrusters, weapons, armor, heat)

**May-June:** Physics and movement (collision, autopilot, bot AI)

**June-July:** Weapons systems (missiles, explosions, targeting)

**July-August:** Navigation systems (warp, waypoints, docking)

**August-September:** UI rebuild (widgets, screens, GM tools)

**September-October:** Testing infrastructure (test harnesses, E2E tests)

**October-November:** Documentation and polish

By November 2024, we had feature parity with the 2022 prototype, plus all the new systems we'd designed but never implemented (energy, heat, missiles, armor, warp, docking).

And the codebase was **clean**.

## What We Gained

Here's what the rewrite bought us:

### 1. Clarity

The architecture is clear. The patterns are consistent. The mental model is simple.

If you read `ARCHITECTURE.md` and then look at the code, it makes sense. There's no "well, this part is weird because of historical reasons."

### 2. Maintainability

Because the patterns are consistent, changes are easier:
- Adding a new ship system? Use the `System` base class, add decorators, done.
- Adding a new UI widget? Use the widget template, subscribe to state, done.
- Adding a new command? Add it to the command handler, validation works automatically.

There's less "how do I do this?" and more "I know the pattern."

### 3. Confidence

The tests give us confidence to refactor. We changed the collision detection library in October 2024—tests caught the regressions, we fixed them, merged confidently.

Without tests, that change would've been terrifying.

### 4. Performance

The new architecture is more efficient:
- Per-ship rooms reduce network traffic (clients only get relevant data)
- Spatial hashing speeds up collision detection
- Memory leak fixes mean the server doesn't degrade over time

We can run longer sessions with more ships without performance degradation.

### 5. Community Readiness

The documentation, tests, and clear architecture make Starwards approachable for contributors.

The 2022 codebase was a maze. The 2024 codebase is a **platform**.

## The Lessons from EmptyEpsilon

This isn't the first time we've learned the "rewrite the foundation" lesson.

Back in January 2021, we wrote "The Epsilon Saga"—a post about our experience forking EmptyEpsilon. We spent months trying to build on top of EmptyEpsilon's codebase, hit architectural limitations, and eventually decided to fork (and then build Starwards from scratch).

That experience taught us:
- Prototypes are valuable for learning, not for production
- Architecture matters more as projects scale
- Sometimes starting fresh is faster than refactoring

And yet, we still ended up in the same place with Starwards' prototype. We had to learn the lesson twice.

But that's how learning works. You know something intellectually, then you experience it, and then you *know* it.

## The Cost

Let's not pretend the rewrite was free. It cost us:

**Time:** Eight months of development. All the features we could've built if we'd kept iterating on the prototype.

**Momentum:** The blog went silent. The community went quiet. We looked inactive.

**Risk:** What if the rewrite failed? What if we couldn't achieve feature parity? We'd have wasted eight months with nothing to show.

These are real costs. And they're why "rewrite from scratch" is usually bad advice.

But in our case, the benefits outweighed the costs. And we're confident that was the right call.

## When to Rewrite (and When Not To)

So, when *should* you rewrite?

Our criteria:
1. **You've validated the concept** — Don't rewrite your first prototype. Build it, prove it works, *then* consider rewriting.
2. **You have a clear plan** — Know what the new architecture looks like before you start. Don't rewrite "to figure it out."
3. **You're willing to pay the time cost** — Rewrites take longer than you think. Be honest about the timeline.
4. **You can carry forward the knowledge** — The value isn't in the old code, it's in what you learned building it.

If you meet those criteria, a rewrite can be the right move.

If you don't, keep iterating.

## The Foundation is Solid

As of November 2024, the rewrite is done. The foundation is solid.

We have:
- Clean architecture that scales
- Comprehensive documentation
- Test coverage that gives us confidence
- Patterns that are consistent and learnable

And on top of that foundation, we've built:
- Energy, heat, and coolant systems
- Missiles, torpedoes, and explosions
- Sectional armor with penetration mechanics
- Bot AI with tactical orders
- Warp drives, waypoints, and docking
- Targeting, fire control, and combat polish

The rewrite was the right call. And now, finally, we're ready to build forward without constantly fighting the architecture.

---

**Next in this series:** "State of Starwards 2025: What's Next" — where we look at what's been achieved, what's still missing, and where we're heading in the year ahead.
