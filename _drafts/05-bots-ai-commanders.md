---
layout: post
title: "Bots, Autopilots, and AI Commanders"
subtitle: From spiral bug to sophisticated tactical AI
tags: [product, gm, technology, game-design]
---

Let's go back to June 2022. Our last blog post before the long silence. The title was "Working on simple AI commands."

We showed a demo: a ship receiving a "go to" command from the GM. The ship was supposed to navigate to the clicked position.

It worked! Sort of. The ship started moving. But then it started turning. And kept turning. And kept turning. It spiraled endlessly, never reaching its destination.

We called it the **spiral bug**.

At the time, we thought it was a simple math error. A sign issue in the rotation calculation, maybe. We'd fix it and move on.

What we didn't realize was that the spiral bug was the *symptom* of a much deeper problem: we didn't have a proper autopilot system. We were trying to bolt AI behavior onto manual controls, and it was fundamentally broken.

Fast forward to March 2024. Pull request [#1640](https://github.com/starwards/starwards/pull/1640): "Add bot AI system."

The spiral bug is gone. And in its place is a complete AI framework with:
- Tactical orders (MOVE, ATTACK, FOLLOW)
- Idle behaviors (PLAY_DEAD, ROAM, STAND_GROUND)
- Smart pilot integration (the autopilot we should have built first)
- GM command interface (right-click to order ships around)

Ships don't just spiral anymore. They *think*.

## The Problem: Manual Controls ≠ Autopilot

Here's what we learned: you can't build an AI by simulating button presses.

Our first attempt at "go to" worked like this:
1. Calculate angle to target
2. Adjust ship's rotation toward that angle (like pressing left/right)
3. Apply forward thrust (like pressing W)
4. Hope it works

The problem is that manual controls are designed for *continuous human input*. You're constantly correcting, adjusting, compensating. The controls don't have built-in smarts—you're the smart part.

An AI needs different primitives:
- "Rotate to this angle and hold it"
- "Navigate to this position and stop when you arrive"
- "Match velocity with this other ship"

These are higher-level behaviors. You can't build them by toggling `rotation` and `boost` every frame.

## The Solution: Smart Pilot

The first step was building a proper autopilot: the **smart pilot** (`smart-pilot.ts`).

The smart pilot has three modes:

### Mode 1: Manual

The smart pilot is off. The ship is controlled by player input (or AI simulating player input, which we don't use anymore).

This is the mode for human-piloted ships.

### Mode 2: Angle Targeting

The smart pilot is told: "Point the ship at this angle."

It calculates the difference between current heading and target angle, applies appropriate rotation thrust, and uses damping to avoid overshooting.

```typescript
const angleDiff = normalizeAngle(targetAngle - currentAngle);
const rotationThrust = clamp(angleDiff * rotationGain, -1, 1);
```

The `rotationGain` is tuned so the ship smoothly rotates to the target angle and holds it without oscillating.

This mode is used for:
- Pointing at a target (weapons fire)
- Holding a specific heading (formation flying)
- Orienting for a maneuver (facing direction of travel)

### Mode 3: Position Targeting

The smart pilot is told: "Navigate to this position."

This is the big one. This is what "go to" should have been.

The smart pilot calculates:
1. Vector to target position
2. Desired velocity to reach target (proportional to distance)
3. Required thrust to achieve that velocity (based on current velocity and mass)

```typescript
const toTarget = {
  x: targetPos.x - ship.x,
  y: targetPos.y - ship.y
};
const distance = Math.hypot(toTarget.x, toTarget.y);

const desiredVelocity = {
  x: (toTarget.x / distance) * approachSpeed,
  y: (toTarget.y / distance) * approachSpeed
};

const velocityError = {
  x: desiredVelocity.x - ship.vx,
  y: desiredVelocity.y - ship.vy
};

// Apply thrust to correct velocity error
```

The `approachSpeed` scales with distance—the ship moves faster when far away and slows down as it approaches. This creates a smooth deceleration, stopping exactly at the target (or close enough).

And crucially: **the ship uses its maneuvering thrusters correctly**. It can thrust forward, backward, left, right—whatever direction is needed to achieve the desired velocity.

No more spiraling. The ship just... goes where you tell it.

## The Bot AI System: Orders and Behaviors

With the smart pilot working, we could finally build real AI on top of it.

The `automation-manager.ts` gives each bot ship:
- An **order:** What the ship is currently trying to do
- An **idle strategy:** What the ship does when it has no order

### Orders

Bots can receive four types of orders:

#### 1. NONE

No order. The bot follows its idle strategy.

#### 2. MOVE

Navigate to a specific position.

The bot activates the smart pilot in position targeting mode with the specified coordinates. It navigates to the position and stops.

Once it arrives, the order is complete. The bot returns to idle behavior.

**GM use case:** "Move this patrol ship to waypoint Alpha."

#### 3. ATTACK

Pursue and engage a specific target.

The bot:
1. Activates smart pilot in position targeting mode, targeting the enemy's current position
2. Updates the target position every frame (pursuing a moving target)
3. Rotates to face the target (for weapons fire)
4. Fires weapons when in range
5. Continues until target is destroyed or out of range

**GM use case:** "Attack the player's ship." (For scenarios, boss fights, etc.)

#### 4. FOLLOW

Maintain formation with a specific target.

The bot:
1. Calculates an offset position relative to the target (e.g., "500m behind and 200m to the right")
2. Navigates to that offset position
3. Updates the offset position as the target moves
4. Matches the target's velocity to stay in formation

**GM use case:** "Form a wing with this ship." (Escort missions, squadron combat, etc.)

### Idle Strategies

When a bot has no order (or completes its order), it falls back to its idle strategy:

#### 1. PLAY_DEAD

The bot does nothing. Engines off, drifting, no rotation.

**Use case:** Derelict ships, damaged ships, ambush setups (the ship "plays dead" until triggered).

#### 2. ROAM

The bot picks a random nearby position and navigates to it. Upon arrival, it picks another random position. Repeat forever.

**Use case:** Patrol ships, wildlife (if you have space creatures), ambient traffic.

#### 3. STAND_GROUND

The bot stays at its current position but rotates to face the nearest threat.

If an enemy comes within a certain range, the bot automatically engages (switches to ATTACK order).

**Use case:** Defensive positions, turrets, guard ships.

### The Result: Ships That Feel Alive

With orders and idle strategies combined, you can create complex behaviors:

**Patrol route:**
- Set up waypoints
- Give the bot MOVE orders to each waypoint in sequence
- Set idle strategy to ROAM

**Ambush:**
- Place bot ships with PLAY_DEAD strategy
- Trigger ATTACK orders when the player enters the zone

**Escort mission:**
- Give escort ships FOLLOW orders targeting the player
- Set idle strategy to STAND_GROUND (if player stops, they guard)

**Dynamic combat:**
- GM issues ATTACK orders to enemy ships mid-mission
- Ships break from patrol routes and engage
- Defeated ships return to ROAM (if still functional)

The GM has *agency*. The bots aren't scripted—they're *commanded*.

## The GM Interface: Right-Click Orders

We built a GM interface that makes issuing orders *trivial*.

In the GM screen:
1. Select a bot ship
2. Right-click on the map
3. Context menu appears: "Move Here," "Attack Target," "Follow Target," "Clear Orders"
4. Click one

The order is issued instantly. The bot responds.

You can control an entire fleet this way. Click, click, click—ships break formation, engage targets, regroup, pursue. It's intuitive, it's fast, and it's *powerful*.

And because orders are just data (stored in the ship's state), you can also issue them programmatically via the scripts API or Node-RED integration (more on that in Post 8).

## Autopilot for Players: Not Just for Bots

Here's a bonus: the smart pilot isn't just for bots. **Players can use it too.**

The smart pilot has UI controls:
- Click on the map → smart pilot navigates there (position targeting)
- Click on a target → smart pilot faces it (angle targeting)
- Toggle autopilot off → back to manual control

This is *huge* for solo players or small crews. If you're running a ship with only two people, the pilot doesn't have to manually fly every approach vector. They can autopilot to a waypoint, then take over manually for combat.

Or in a multi-crew setup, the pilot can delegate navigation to the autopilot and focus on evasive maneuvers during combat.

It's not a crutch—it's a tool. And like all tools, skilled use makes you more effective.

## The Evolution: From Spiral to Sophistication

Let's appreciate how far we've come:

**June 2022:**
- Basic "go to" command
- Spiral bug
- No autopilot
- No orders system
- No idle behaviors

**November 2024:**
- Smart pilot with three modes
- Position targeting that actually works
- Four order types (MOVE, ATTACK, FOLLOW, NONE)
- Three idle strategies (PLAY_DEAD, ROAM, STAND_GROUND)
- GM interface with right-click commands
- Player-accessible autopilot
- Programmatic API for external control

We didn't just fix the spiral bug. We built a complete AI framework.

## The LARP Impact: GMs and Pilots

From a LARP perspective, this system delivers two key benefits:

### 1. GM Empowerment

GMs can now:
- Run complex multi-ship scenarios without scripting
- React dynamically to player actions (issue new orders mid-mission)
- Control NPCs and enemy forces intuitively
- Create living environments (patrol ships, ambient traffic, guards)

The GM isn't limited by what's pre-programmed. They're commanding a fleet.

### 2. Pilot Assistance

Players can:
- Use autopilot to reduce workload (especially in small crews)
- Focus on tactical decisions rather than constant manual flying
- Navigate long distances without tedium
- Still take manual control when precision is needed

The autopilot doesn't replace skill—it *amplifies* it.

## What's Next: Smarter AI

The current AI is functional, but it's not *smart*. It follows orders, but it doesn't make decisions.

Future enhancements might include:

**Tactical AI:** Bots choose their own maneuvers based on threat assessment. Evasive rolls, flanking positions, retreat when damaged.

**Squadron AI:** Bots coordinate with each other. One ship draws fire while another flanks. Wingmen cover each other.

**Dynamic targeting:** Bots prioritize targets based on threat level, not just proximity.

**Evasion AI:** Bots dodge incoming missiles, use asteroids for cover, perform barrel rolls.

But for now, the foundation is solid. Bots can move, fight, follow, and patrol. And that's enough to make the game *playable*.

## The Promise Kept (Again)

In June 2022, we promised simple AI commands. We showed a broken prototype and said "we're working on it."

Two years later, we delivered:
- A complete autopilot system
- A tactical orders framework
- Idle behaviors that make ships feel alive
- A GM interface that's actually usable
- And yes, we fixed the spiral bug

The journey from spiral to sophistication is complete.

---

**Next in this series:** "Getting Around: Warp, Waypoints, and Docking" — where we expand the universe beyond a single combat zone and show you how ships finally travel, navigate, and resupply.
