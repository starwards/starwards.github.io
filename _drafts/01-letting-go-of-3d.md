---
layout: post
title: "Letting Go of 3D: A Focus Decision"
subtitle: Why we removed the 3D rendering code (and what we learned about priorities)
tags: [product, design, technology]
---

In March 2024, we deleted all the 3D rendering code from Starwards. This was the code we'd spent months building in 2021 and showed off in early blog posts. The entire `modules/browser/src/3d/` directory, along with the 3D main screen view—all gone.

[Pull Request #1659](https://github.com/starwards/starwards/pull/1659) if you want to see the diff. It's 4,523 lines of deletions.

This probably seems strange. We built something, showed it off, then deleted it? What happened?

## Why We Built 3D In The First Place

Back in 2021, we wanted Starwards to have feature parity with existing bridge simulators and the "wow factor" that comes with 3D space views. It's not strictly necessary for a LARP game, but it adds to immersion—seeing your ship from outside, watching explosions in 3D space, having a cinematic view of combat.

We had the technical capability to do it (Three.js integration with our existing PixiJS rendering), so we built it. And it worked. We had 3D ship models, particle effects, skyboxes, proper lighting.

But as we continued developing other systems, we started noticing the cost.

## The Cost of 3D

The 3D rendering wasn't just code—it was an entire pipeline:

**Technical complexity:** Integrating Three.js alongside PixiJS meant managing two rendering systems. Different update loops, different coordinate systems, different performance characteristics.

**Asset creation:** 3D models need to be created, textured, and optimized. Every new ship type meant 3D modeling work, not just defining stats and behavior.

**Maintenance burden:** Both rendering systems needed to be kept in sync with game state. Changes to ship systems often meant updating both 2D and 3D representations.

**Performance overhead:** 3D rendering is expensive. We were already running a physics simulation at 60Hz and syncing state across multiple clients. Adding 3D rendering on top was pushing performance limits.

The critical realization: all this effort was going toward a feature that wasn't essential for the core LARP experience.

## What LARP Actually Needs

In a bridge simulator LARP, players are at stations. The pilot needs helm controls and a tactical view. The weapons officer needs targeting information. The engineer needs system status displays. The captain needs an overview of the tactical situation.

What they need most is *information*, presented clearly and quickly.

The 2D tactical overhead view does this better than 3D for most purposes:
- You can see all ships in an engagement at once
- Distance and position relationships are clear
- Damaged armor sections are easy to visualize
- Multiple contacts don't occlude each other

The 3D view looks cool, but it's not where players spend their time during actual play. It's a nice-to-have, not a must-have.

And in March 2024, when we were focusing efforts on reaching a LARP-playable product, we had to make choices about where to spend development time. The 3D rendering wasn't making the cut.

## The Unity Alternative

Here's the other key piece: we'd successfully built a proof-of-concept of connecting to our Colyseus server using the Unity game engine.

Colyseus has polyglot capability—clients can be written in any language with a Colyseus client library. The Unity C# client works fine. We proved we could connect Unity to our existing server and sync game state.

This means when we eventually return to 3D rendering (and we probably will), we can build it as a completely separate client. A Unity-based 3D view that connects to the same server as the web client, receives the same state updates, and renders everything in proper 3D.

That's actually the right technical choice anyway. The 3D main screen is so different from the station UI (different requirements, different input handling, different rendering approach) that having it as a separate client makes sense administratively and architecturally.

So we're not abandoning 3D forever. We're deferring it until we have bandwidth to do it properly, and when we do, it'll be a separate Unity client rather than trying to jam Three.js into our web-based station interface.

## The Decision

Given all this, the decision became straightforward:
1. Remove the 3D code from the main client to reduce complexity and maintenance burden
2. Focus development effort on the core systems needed for LARP play (energy, combat, navigation, damage)
3. Revisit 3D later as a separate Unity client when it makes sense

So we deleted it. All of it. The lights, meshes, particle systems, skybox, camera management—everything in that 4,523-line diff.

## What We Gained

Since removing the 3D code, development has been faster. We don't have to maintain two rendering pipelines. We don't have to create 3D assets. We don't have to worry about 3D performance.

And we've shipped all the core systems that were on the roadmap:
- Energy, heat, and coolant management
- Missiles and torpedoes
- Sectional armor
- Bot AI and autopilot
- Warp drives and navigation
- Docking systems

Would we have shipped all that if we'd kept the 3D rendering? Probably eventually, but it would have taken longer. Every feature would have needed both 2D and 3D implementations.

## The Lesson

The lesson isn't "3D is bad" or "we made a mistake building it in the first place." The lesson is about focus and priorities.

When you're building a complex system, especially with limited development resources, you have to make choices about what to build, what to defer, and what to cut. Those choices should be based on what actually serves your core goals.

For Starwards, the core goal is a functional LARP bridge simulator. The 3D rendering was supporting that goal, but it wasn't essential to it. So when we needed to focus our efforts, it was the right thing to cut.

We can always add it back later (as a separate Unity client). But for now, we're 2D and focused on depth over spectacle.

---

**Next in this series:** "Engineering Complete: Energy, Heat, and System Effectiveness" — where we show you the complete engineering systems we built with all that reclaimed development time.
