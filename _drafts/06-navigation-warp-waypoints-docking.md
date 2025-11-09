---
layout: post
title: "Getting Around: Warp, Waypoints, and Docking"
subtitle: The universe just got bigger
tags: [product, technology, stations, game-design]
---

For the first three years of Starwards development, the game universe was essentially **one room**.

Sure, you could fly in any direction. Theoretically, you could fly 100,000 km in a straight line if you wanted to wait long enough. But in practice, every scenario, every test, every demo was confined to a single combat zone: a few ships, some asteroids, maybe 20km across.

We were building a space combat game, not a space *travel* game.

But as we developed more systems—missions, scenarios, multi-ship operations—we kept running into the same limitation: how do ships get from one place to another?

If a mission requires traveling from a station to a distant combat zone, how does that work? Do players manually fly for 20 minutes? Do we just teleport them? Do we need a loading screen between zones?

The answer, we decided, was: **warp drives, waypoints, and docking**.

Now, finally, ships can travel. They can navigate. They can resupply. The universe isn't one room anymore—it's as big as we want it to be.

## The Problem: Scale vs. Time

Let's talk about the fundamental problem of space games: **space is really, really big**.

Even within a single solar system, distances are absurd. Earth to Mars is ~225 million kilometers at closest approach. Even at a ludicrous 1000 km/s (which is *way* faster than any realistic spacecraft), that's 62 hours of travel time.

You can't ask players to fly manually for 62 hours.

So space games make trade-offs:

**Option 1: Compress space.** Make everything closer. Star Citizen does this—planets are much closer than they should be. Elite Dangerous does it too. It works, but it sacrifices scale.

**Option 2: Fast travel.** Jump gates, hyperlanes, FTL. You travel "instantly" between zones. Freelancer, Eve Online, and many others use this. It works, but it sacrifices continuity (you're not flying through space—you're teleporting).

**Option 3: Time compression.** Make time pass faster during travel. Some games let you "accelerate time" during transit. It works, but it's narratively weird (everyone else is in slow motion?).

**Option 4: Warp drives.** Let ships move *very fast* for short bursts. You're still flying continuously through space, but at 100x or 1000x normal speed. This is what we chose.

## Warp Drive: Going Fast Without Breaking Things

The warp drive system (`warp.ts`) is conceptually simple: **it makes your ship go faster**.

But the implementation has nuance.

### Warp Levels

The warp drive has several properties:
- `currentLevel`: The actual warp multiplier right now (e.g., 10x, 100x, 1000x)
- `desiredLevel`: The level the crew has requested
- `chargeLevel`: How much charge the warp drive has accumulated (0-100%)

Warp doesn't engage instantly. You have to charge it first.

### Charging and Engagement

When the crew sets `desiredLevel` to, say, "Warp 5" (100x speed), the warp drive begins charging:

```typescript
chargeLevel += chargeRate * dt;

if (chargeLevel >= 100) {
  currentLevel = desiredLevel; // Engage!
}
```

The `chargeRate` depends on:
- Power allocation (more power = faster charge)
- Warp drive effectiveness (damaged drive = slower charge)
- Heat (overheated drive = no charge)

Once fully charged, the warp drive engages. The ship's velocity is multiplied by `currentLevel`:

```typescript
effectiveVelocity = baseVelocity * warpLevel;
```

A ship moving at 100 m/s with Warp 100 is now effectively moving at 10,000 m/s. Distances that took minutes now take seconds.

### Disengagement

To drop out of warp, the crew sets `desiredLevel` to 0. The warp drive discharges:

```typescript
chargeLevel -= dischargeRate * dt;

if (chargeLevel <= 0) {
  currentLevel = 0; // Back to normal space
}
```

Discharge is faster than charge (you can emergency-drop out of warp quickly), but it's not instant. This prevents "blink" tactics where you warp in, fire, and warp out instantly.

### Heat and Power

Warp drives generate *a lot* of heat. Engaging warp at high levels can quickly overheat the drive if you don't allocate enough coolant.

They also consume significant power. If your reactor is damaged and you're in a brown-out, you might not have enough power to charge the warp drive.

This ties warp travel into the engineering system (from Post 2). The engineer has to balance:
- Power to warp drive (so it charges)
- Coolant to warp drive (so it doesn't overheat)
- Power and coolant to other systems (so you're not defenseless)

Warp travel isn't "press button, go fast." It's a coordinated effort.

### Warp Combat?

Can you fight while in warp?

Technically, yes. But it's a bad idea.

Your ship is moving at 100x speed. Your weapons fire projectiles at normal speed. You'll overshoot any target before your bullets arrive.

Enemy ships would have to predict your position seconds in advance to hit you. Missiles would struggle to track you (their rotation speed can't keep up).

In practice, warp is for *travel*, not combat. You warp to the combat zone, drop out of warp, and then fight.

(Though "warp drive failure mid-combat" is a great engineering challenge scenario for LARP...)

## Waypoints: Navigation Markers in Space

Warp drives let you go fast. But where are you going?

Without landmarks, space is featureless. You can't say "fly toward that planet" if there are no planets. You can't navigate to "the asteroid belt" if asteroids aren't clustered.

Solution: **waypoints** (`waypoint.ts`).

Waypoints are named markers placed in space:

```typescript
class Waypoint {
  @gameField() name: string;
  @gameField() x: number;
  @gameField() y: number;
}
```

Dead simple. A name, a position. That's it.

### GM-Placed Waypoints

The GM can place waypoints on the map:
- "Alpha Station"
- "Combat Zone Bravo"
- "Asteroid Field"
- "Jump Point to Sector 7"
- "Ambush Point (don't tell the players)"

These show up on the tactical display (if you have sensors) and on the navigation screen.

### Navigation Workflow

The crew workflow becomes:
1. Pilot: "Where are we going?"
2. Captain: "Navigate to waypoint Alpha."
3. Pilot clicks on Alpha waypoint, autopilot engages
4. Engineer: "Charging warp drive."
5. Pilot: "Engaging warp 5."
6. *Ship travels at 100x speed toward Alpha*
7. Pilot: "Approaching waypoint, disengaging warp."
8. *Ship drops out of warp near Alpha*
9. Pilot: "We've arrived."

This is the *feel* we wanted. It's not instant teleportation. It's not manual flying for 20 minutes. It's coordinated navigation with clear steps and crew communication.

### Waypoints for Missions

Waypoints also enable mission design:

**Mission: Escort Convoy**
- Waypoint 1: "Convoy Start" (players meet the convoy here)
- Waypoint 2: "Ambush Zone" (GM spawns enemies when players arrive)
- Waypoint 3: "Convoy Destination" (mission completes on arrival)

The GM can dynamically create, move, and remove waypoints during the mission. They're not baked into the map—they're part of the scenario's *state*.

### Waypoint Sharing

If multiple ships are in communication, they share waypoint data. Your scout ship discovers a hidden station and marks it as a waypoint—now your whole fleet can navigate to it.

This creates coordination gameplay: "Scout ahead, mark targets, fleet warps in."

## Docking: Ship-to-Ship Attachment

Warp drives get you to the destination. Waypoints tell you where to go. But once you arrive, what if you need to:
- Resupply ammunition
- Repair damage
- Refuel
- Transfer crew
- Board an enemy ship

Answer: **docking** (`docking.ts`, `docking-manager.ts`).

### Docking Mechanics

Two ships can dock if:
1. They're within docking range (~500m, configurable)
2. Their relative velocity is low (can't dock while zooming past each other)
3. Both ships consent (can't force-dock with a hostile ship, unless you're boarding)

Once docked:
- The ships are physically linked (move together)
- You can transfer resources (ammo, fuel, repair bots)
- You can transfer crew (via EVA or boarding tubes)
- The docked ship can be towed (the parent ship's engines move both)

### Use Cases

**Resupply:**
- Fighter docks with carrier
- Carrier transfers missiles to fighter's magazine
- Fighter undocks, returns to combat

**Repair:**
- Damaged ship docks with repair ship
- Repair ship allocates repair bots to fix armor and systems
- Ship undocks when repairs complete

**Towing:**
- Disabled ship (no engine power) is docked by rescue ship
- Rescue ship tows the disabled ship back to base

**Boarding:**
- Pirate ship docks (forcefully) with merchant ship
- Boarding party transfers to merchant ship
- (This requires crew/marine systems, which aren't fully implemented yet, but the docking framework supports it)

### Docking Workflow

The typical workflow:

1. Helm: "Approaching docking range with Alpha Station."
2. Captain: "Request docking clearance."
3. Alpha Station (GM or AI): "Clearance granted, dock at port 2."
4. Helm: *Maneuvers to within 500m, matches velocity*
5. Helm: "Docking... locked."
6. Engineer: "Resupply in progress, 10 missiles transferred."
7. Captain: "Undock when ready."
8. Helm: "Undocking... clear."

It's a multi-step process that involves communication and coordination. Not just "press F to resupply."

## Enhanced Movement Controls: The Full Pilot's Toolkit

With warp drives and docking, we also expanded the basic movement controls to give pilots more tools.

In addition to the original `rotation` and `boost`, we now have:

### Strafe (Lateral Movement)

`strafe: [-1, 1]` — side-to-side thrust without rotating.

Useful for:
- Docking maneuvers (slide into position)
- Evasion (strafe while keeping forward guns on target)
- Formation flying (adjust position without changing heading)

### Anti-Drift

`antiDrift: [0, 1]` — automatic thrust to oppose current velocity.

This is the "stop" button. Instead of manually thrusting backward to slow down, you engage anti-drift and the ship automatically applies reverse thrust to kill velocity.

Useful for:
- Coming to a stop at a waypoint
- Holding position
- Emergency braking

### Breaks

`breaks: [0, 1]` — rapid deceleration, high heat.

This is *aggressive* anti-drift. Maximum thrust in the opposite direction of velocity, regardless of heat cost.

Useful for:
- Emergency stops (avoid collision)
- Combat maneuvers (snap-stop to let an enemy overshoot)

The trade-off is heat generation. Hold breaks too long, your thrusters overheat. But for short bursts, it's worth it.

### Afterburner (Enhanced)

`afterBurner: [0, 1]` — rotation boost with high heat.

We had this before, but now it's integrated with the heat system (from Post 2). Afterburner gives you higher rotation speed, but generates *significant* heat.

Dogfighting with afterburner is possible, but you need to manage coolant and watch your heat gauge. Overheat your maneuvering system, you lose the ability to turn.

### The Complete Control Scheme

Putting it all together, a pilot now has:
- `rotation` — turn left/right
- `boost` — forward/reverse thrust
- `strafe` — lateral movement
- `antiDrift` — velocity opposition
- `breaks` — emergency deceleration
- `afterBurner` — rotation boost

It's a rich control palette. Simple enough to learn, deep enough to master.

And all of it is accessible via:
- Keyboard (WASD + modifiers)
- Gamepad (dual-stick control)
- Autopilot (smart pilot takes over)

## The Movement Manager: Unifying It All

Under the hood, the `movement-manager.ts` unifies all these controls.

It takes input from:
- Player controls (keyboard/gamepad)
- Autopilot (smart pilot)
- Bot AI (automation manager)

And it outputs:
- Thruster activations (which thrusters fire, at what power)
- Rotation thrust
- Velocity changes

The movement manager handles:
- Anti-drift calculations (which direction to thrust to oppose velocity)
- Breaks logic (maximum reverse thrust)
- Afterburner modulation (boost rotation capacity, track heat)
- Warp drive integration (velocity multiplier)

It's the glue that makes all the movement systems work together.

## What This Means for LARP: Expanded Scope

With warp, waypoints, and docking, the scope of possible missions expands dramatically:

**Patrol Mission:**
- Warp to waypoint Alpha
- Scan the area
- Warp to waypoint Bravo
- Encounter hostiles
- Engage, then warp home

**Resupply Run:**
- Dock with station
- Load cargo and ammunition
- Warp to forward outpost
- Deliver supplies (dock, transfer)
- Warp home

**Search and Rescue:**
- Distress signal at waypoint Delta
- Warp to Delta
- Find damaged ship
- Dock and tow back to base

**Fleet Operations:**
- Multiple ships coordinate via shared waypoints
- Warp in formation (staggered arrival times)
- Docking mid-mission for repairs

The game isn't limited to "spawn in arena, fight, end scenario." It can be a *journey*.

## What's Next: Jump Networks and Hyperspace

The current warp system is continuous—you're still flying through normal space, just faster. This works, but it has limitations:

**Jump Gates:** Specific points that enable FTL jumps to other systems. You can't warp anywhere—you warp to gates, then jump.

**Hyperspace:** A separate "layer" of space where distances are compressed. Enter hyperspace, travel, exit at destination. (Think Star Wars or Babylon 5.)

**Navigation Hazards:** Warp interdiction fields, gravity wells, asteroid interference. Things that make navigation *dangerous*, not just a button press.

But for now, warp drives and waypoints are enough to make the universe feel big.

## The Promise: A Bigger Universe

We started with one room. Now we have warp drives, navigation markers, and docking systems.

Ships can travel. Missions can span multiple locations. The universe is as big as we design it to be.

And most importantly: travel isn't boring. It's coordinated, it's tactical, and it creates LARP moments.

The universe just got bigger.

---

**Next in this series:** "Targeting, Fire Control, and Combat Refinements" — where we polish the combat experience with sophisticated targeting systems and improved physics.
