---
layout: post
title: "Targeting, Fire Control, and Combat Refinements"
subtitle: Polishing the dogfight experience with smarter systems
tags: [product, weapons, technology, dogfight]
---

We've talked about big features: missiles, armor, energy systems, warp drives. These are the headline features—the ones that define what Starwards *is*.

But there's another category of work that's equally important but harder to showcase: **polish**.

Polish is the accumulation of small improvements that make a system feel *right*. It's not one dramatic change—it's dozens of subtle refinements that add up to a smooth, satisfying experience.

In combat, polish means:
- Targeting that works intuitively
- Physics that feels responsive
- Weapons that fire when you expect them to
- Radar that provides useful information
- Collisions that don't glitch

This post is about that polish. The targeting systems, fire control improvements, radar enhancements, and physics refinements that took the dogfight milestone from "functional" to "fun."

It's not glamorous work. But it matters.

## The Targeting System: Smarter Lock-Ons

In the early builds, targeting was simple: click on a ship, that's your target. Fire your weapons, they aim at the target.

But as the game grew more complex, "click on a ship" became insufficient. We needed:
- Filter by type (target ships, ignore projectiles)
- Filter by faction (target enemies, ignore friendlies)
- Filter by range (target only what you can actually hit)

The solution: a proper **targeting system** (`targeting.ts`) with configurable filters.

### Target Filters

The targeting system now supports three filters:

#### 1. `shipOnly`

If true, only target ships. Ignore projectiles, explosions, asteroids, waypoints.

This is the default for most weapons. Your chainguns should fire at enemy ships, not at missiles flying past (that's what point defense is for).

#### 2. `enemyOnly`

If true, only target ships that are hostile to you.

This prevents friendly fire. Your weapons won't lock onto allied ships (unless you manually override, which is sometimes necessary for... reasons).

The faction system determines who's an enemy. If Ship A is faction "Red" and Ship B is faction "Blue," and Red/Blue are hostile, then `enemyOnly` will only target Blue ships for Red ships (and vice versa).

#### 3. `shortRangeOnly`

If true, only target ships within a certain range (typically 1000-2000m).

This is useful for close-range weapons (chainguns, point defense). You don't want your CIWS locking onto a ship 10,000m away—it should focus on immediate threats.

### Target Selection Logic

When the weapons officer clicks "next target" (or the targeting system auto-selects), it:
1. Gets a list of all potential targets in the area
2. Filters out anything that doesn't match `shipOnly`, `enemyOnly`, `shortRangeOnly`
3. Sorts by distance (or threat level, if implemented)
4. Selects the closest valid target

The result: targeting feels *smart*. You're not clicking through asteroids and friendly ships to find the enemy. The system knows what you want to shoot.

### Manual Override

Of course, you can still manually click on any object to target it. The filters are just defaults.

This allows for:
- Targeting specific threats (ignore the weak fighter, target the missile cruiser)
- Shooting asteroids (for mining, or to create debris fields)
- Friendly fire (if the situation demands it, you can override)

The system is smart by default, flexible when needed.

## Fire Control: Enhanced Chaingun Management

The chaingun system got several refinements to make it feel better:

### Rate of Fire Modulation

Originally, chainguns fired at a fixed rate. Now, the rate of fire is affected by:
- Heat level (overheated guns fire slower)
- Power level (low power = sluggish fire rate)
- Damage state (damaged guns misfire or jam)

The `chain-gun-manager.ts` tracks a `rateOfFireFactor` that modulates the base fire rate:

```typescript
effectiveFireRate = baseFireRate * rateOfFireFactor;
```

If your guns are running hot (80°C+), `rateOfFireFactor` drops to 0.7. Your guns still fire, but at 70% speed. This creates pressure to manage heat—you *can* keep firing, but you're less effective.

### Ammo Loading Mechanics

Chainguns now have realistic loading mechanics:
- Ammo is stored in magazines (limited capacity)
- Guns must reload when empty (takes time)
- Reload time is affected by crew efficiency and damage

The weapons officer has to manage ammo:
- Fire in bursts (conserve ammo)
- Reload during lulls in combat
- Call out when ammo is low

It's a small thing, but it adds texture to the weapons role.

### Visual Feedback

When you fire, you see:
- Muzzle flash (PixiJS particle effect)
- Projectile tracers (visual confirmation of fire)
- Heat indicator (rising gauge)
- Ammo counter (decreasing rounds)

All of this *feels* responsive. You press fire, you see immediate visual feedback. The gun feels like it has weight and consequences.

## Radar Enhancements: Making Damage Matter

Way back in June 2022, our last blog post was titled "Radar Damage." We demonstrated that radar malfunctions cause the range to flicker—sometimes you see 5000m, sometimes 2000m, creating uncertainty.

That system still exists, and it's been refined:

### Malfunction Mechanics

The radar has a `malfunctionRangeFactor` that varies based on damage:

```typescript
effectiveRange = baseRange * malfunctionRangeFactor;
```

When the radar is healthy, `malfunctionRangeFactor = 1.0` (full range).

When the radar is damaged (but not broken), `malfunctionRangeFactor` fluctuates randomly between, say, 0.4 and 1.0. Your radar alternates between showing 2000m and 5000m. Enemy ships flicker in and out of detection.

When the radar is broken, `malfunctionRangeFactor = 0` (you're blind).

This creates tension:
- Is that contact real, or a ghost?
- Did the enemy ship disappear, or is my radar malfunctioning?
- Should I trust this reading, or is my equipment damaged?

### Radar Sharing

We also added **radar sharing** between friendly ships.

If Ship A has a working radar and Ship B's radar is broken, Ship B can see Ship A's radar data (if they're networked).

This creates teamwork:
- "Our radar is down, relying on your data."
- "We've got eyes on the enemy, broadcasting to the fleet."
- Scouts with good sensors can relay information to heavy ships with damaged radar.

It's a mitigation strategy (as we discussed in the original post), and it makes multi-crew and multi-ship play more interesting.

### Range Rings

The radar display now shows range rings at fixed intervals (1000m, 2000m, 3000m, etc.), making it easier to judge distances at a glance.

When your radar malfunctions, the range rings flicker too, visually reinforcing that your sensors are unreliable.

## Physics Refinements: The Feel of Flight

One of the hardest things to communicate in game development is **feel**.

A game can have perfect physics equations and still feel wrong. The ship is too floaty. The collisions are too bouncy. The rotation is too sluggish. These are subjective, but they matter.

We made several physics refinements to improve the feel of flight:

### Raycast Projectile Collision

Originally, projectiles used continuous collision detection—checking every frame if the projectile overlaps with a ship.

This worked, but at high speeds, projectiles could "tunnel" through ships (move so fast in one frame that they skip past the collision box).

Solution: **raycast intersection**.

Every frame, we:
1. Calculate the ray from the projectile's previous position to its current position
2. Check if that ray intersects any ships
3. If yes, register a hit at the intersection point

This is mathematically exact. No matter how fast the projectile moves, we'll detect the hit.

```typescript
const ray = {
  start: { x: projectile.prevX, y: projectile.prevY },
  end: { x: projectile.x, y: projectile.y }
};

for (const ship of ships) {
  if (rayIntersectsCircle(ray, ship.position, ship.radius)) {
    // Hit!
  }
}
```

The result: bullets don't magically pass through ships anymore. Every hit registers.

### Spatial Hashing for Collision Detection

As the number of objects in a scene grows (ships, projectiles, asteroids, explosions), naive collision detection becomes expensive. Checking every object against every other object is O(n²).

We integrated the `detect-collisions` library, which uses **spatial hashing** to reduce collision checks to O(n log n).

The space is divided into a grid. Objects are placed in grid cells based on their position. Collision checks only happen between objects in the same cell (or adjacent cells).

This means:
- 100 objects in a scene: ~100 checks instead of 10,000
- Consistent frame rate even in large battles
- No performance degradation as scenarios scale

It's invisible to players, but it makes the game *smooth*.

### Collision Response: Impulse-Based Physics

When ships collide (with each other, or with asteroids), we apply impulse-based collision response.

This means:
1. Calculate the collision normal (direction of impact)
2. Calculate the relative velocity at the collision point
3. Apply an impulse (instantaneous velocity change) to both objects

The impulse is scaled by:
- Mass (heavier ships push lighter ships more)
- Restitution (bounciness—are collisions elastic or inelastic?)

The result: collisions feel *right*. A fighter bouncing off a cruiser doesn't knock the cruiser around. A head-on collision at high speed sends both ships reeling.

We tuned the restitution value to be slightly inelastic (0.3-0.5), so ships don't bounce like rubber balls. They collide, lose some energy, and drift apart.

### Explosion Propagation

When an explosion goes off (from missiles or blast shells), it applies force to all nearby ships:

```typescript
const forceDirection = normalize(ship.position - explosion.position);
const forceMagnitude = explosion.blastFactor * (1 - distance / radius);

ship.velocity += forceDirection * forceMagnitude;
```

The force falls off linearly with distance. Ships at the center of the explosion get shoved hard. Ships at the edge get nudged.

This creates chaos in furball situations. A missile detonates in the middle of a cluster of ships, and they all scatter like billiard balls.

It's *fun*.

## Combat Widget Improvements

The UI also got refinements:

**Targeting Widget:**
- Shows target name, distance, health, faction
- Lock-on indicator (green = locked, red = out of range)
- Lead indicator (shows where to aim for moving targets)

**Weapons Status:**
- Heat gauge per weapon system
- Ammo counter
- Fire rate indicator
- Tube status (for missiles)

**Damage Display:**
- Armor visualization (covered in Post 4)
- System health bars
- Malfunction indicators

All of this information is presented clearly, without clutter. The widgets are modular—you can rearrange them, hide them, resize them.

## What This Means for LARP: Deeper Tactical Play

The refinements collectively create a deeper combat experience:

**Weapons Officer:**
- Uses targeting filters to prioritize threats
- Manages ammo and heat across multiple weapon systems
- Calls out target status ("Locked on hostile at 2500m")
- Coordinates with pilot for lead shots

**Helm:**
- Feels the responsiveness of the controls
- Maneuvers to avoid collisions and explosions
- Positions for optimal firing angles
- Reacts to radar information (or lack thereof)

**Damage Control:**
- Monitors radar health (is the flickering normal or damage?)
- Reports malfunctions affecting sensors and weapons
- Coordinates repairs with engineering

It's not just "press fire, kill enemy." It's coordination, communication, and tactical decision-making.

## The Promise: Combat That Rewards Skill

The original dogfight milestone (March 2021) proved that space combat in Starwards could work. Ships could fly, shoot, and damage each other.

These refinements prove that space combat in Starwards can be *good*. The physics feel right. The targeting is smart. The weapons are satisfying. The radar provides tactical information.

It's the difference between "functional" and "fun."

And that difference matters.

---

**Next in this series:** "The Developer Experience Revolution" — where we address the open-source commitment from 2022 and show how we made Starwards welcoming to contributors with documentation, testing, and tools.
