---
layout: post
title: State of Starwards, April 2026
subtitle: What's built, what works, and what's missing
tags: [product, story, game-design, technology]
---

This is the companion to [We're Back]({% post_url 2026-04-12-were-back %}), which covered the history. This post is about the present.

## What's Built

Starwards has grown from a dogfight prototype into something that resembles an actual bridge simulator. Here's what exists and works today.

### Ship Systems

Every ship runs a set of interconnected subsystems, each with power allocation, heat management, coolant, and the possibility of being damaged or hacked. The core formula is simple:

> effectiveness = power × coolantFactor × (1 - hacked)

If a system overheats (above 100°), it breaks. If it's not getting enough power, it runs at reduced capacity. If the engineer doesn't allocate coolant, heat builds up. This creates the kind of interdependency between crew stations that makes bridge sims interesting — the engineer's choices directly affect what the pilot and gunner can do.

The full subsystem list: **reactor**, **maneuvering**, **thrusters** (directional array), **radar**, **chaingun**, **torpedo tubes**, **magazine**, **armor** (sectional plates), **targeting**, **warp drive**, **docking**, and **smart pilot** (autopilot/bot AI).

### Combat

The [engagement circles]({% post_url 2021-02-27-engagement-circles %}) design from 2021 is fully implemented. Three ranges, three weapon types:

- **Long range (4000m+):** Missiles with homing guidance and proximity detonation. They force evasion and open engagements.
- **Medium range (1000-4000m):** Cannon shells that require leading the target, plus blast shells for area disruption.
- **Close range (0-1000m):** Chaingun furball — the [dogfight]({% post_url 2021-03-20-dogfight-showcase %}) we built first.

Ammunition is finite. Tubes have loading times. Missiles can be dodged if you're fast enough. It all works together.

### Armor

The [Battletech-inspired sectional armor]({% post_url 2021-04-03-damage-system %}) is real now. Ships have directional armor plates (front, rear, left, right — more granular on larger ships). Which plate takes damage depends on the impact angle relative to the ship. When a plate is destroyed, hits penetrate to internal systems. Positioning matters: don't show your damaged side to the enemy.

### Navigation

The game universe is no longer a single 20km combat zone. Warp drives let ships travel at multiples of their base speed (charging takes time and generates heat). Waypoints provide navigation structure. Ships can dock with each other for resupply — reloading missiles, that sort of thing.

### Bot AI and GM Tools

NPC ships have a proper AI system with tactical orders: MOVE, ATTACK, FOLLOW. Idle behaviors include PLAY_DEAD, ROAM, and STAND_GROUND. The GM can right-click on the radar to issue orders, create and destroy objects, and tweak ship parameters in real time. This evolved from the [spiral-bug era]({% post_url 2022-06-12-simple-ai-commands-wip %}) into something that actually works for running scenarios.

### Engineering Station

The ECR (Engineering Control Room) gives the engineer control over power allocation, coolant distribution, and warp. Every system can be tuned between SHUTDOWN, LOW, MID, HIGH, and MAX power. Coolant is a limited resource that has to be distributed across systems based on what's needed right now. Hotkeys make it fast to adjust during combat.

### Infrastructure

On the development side:

- **Colyseus multiplayer** with three room types: SpaceRoom (shared physics simulation), ShipRoom (per-ship bridge state), and AdminRoom (game lifecycle)
- **All state changes** go through JSON Pointer commands — validated, logged, and theoretically replayable
- **Playwright E2E tests** for widget and integration testing
- **Node-RED integration** for external scripting and scenario automation
- **Comprehensive documentation** — architecture, subsystems, physics, patterns, API reference
- **CI/CD** with preview deployments

## What's Missing

We're not LARP-ready yet. Here's what's still needed:

**Corvette-class ships.** We have fighters (1-2 crew). We don't yet have the larger ships (4-6 crew) that would make a proper multi-station bridge experience. The architecture supports it — the subsystem design is ship-class agnostic — but the specific designs and UI layouts aren't done.

**Multi-bridge scaling.** The system is designed for multiple ships, each with their own crew. We haven't stress-tested what happens with 3 ships × 5 crew = 15 simultaneous players. Fleet-level GM tools need work.

**Advanced damage and repair.** Ships take damage and systems break, but the damage reporting is basic. We want narrative damage reports, repair minigames, and better visual feedback (something LCARS-like, maybe).

**Cyber warfare.** The effectiveness formula already has a `hacked` term, but there's no actual hacking gameplay yet. It's a placeholder waiting for a game design pass.

**3D visualization.** Removed from the main codebase in 2024. The plan is still to build a Unity client that connects via Colyseus, but that's future work.

## The Tech Stack

For reference, Starwards is built on:

- **Colyseus** for multiplayer state synchronization
- **PixiJS** for 2D rendering (tactical radar, widgets)
- **React** for UI components
- **TypeScript** throughout
- **Node-RED** for external scripting

The server runs the physics simulation at 60Hz. Clients connect via WebSocket and receive state updates. All game logic lives on the server; clients are views with input.

## What's Next

The immediate focus is getting to a playable LARP scenario. That means corvette-class ships, multi-bridge testing, and enough GM tooling to run a session without things falling apart.

Daniel is coming back to active development, which will help. We're both leaning heavily on AI-assisted development to make progress despite limited time — it's what makes a project of this scope feasible as a side project.

We'll keep the blog updated this time. No promises about frequency, but we're done with four-year silences.
