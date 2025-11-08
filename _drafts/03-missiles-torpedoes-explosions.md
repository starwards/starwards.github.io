---
layout: post
title: "Missiles, Torpedoes, and Big Explosions"
subtitle: Completing the engagement circles with smart munitions that think
tags: [product, weapons, design, technology]
---

Back in February 2021, we wrote a post called "Engagement Circles." The thesis was simple: different weapon systems should operate at different ranges, creating distinct tactical zones.

We outlined three circles:
1. **Long range (4000m+):** Torpedoes and missiles—slow, powerful, avoidable
2. **Medium range (1000-4000m):** Ballistic weapons—faster, less damage, skill-based
3. **Close range (0-1000m):** Chainguns and close-in weapon systems—rapid fire, high heat

At the time, we only had chainguns. The close-range circle was complete. The other two? Promises.

Well, it's 2024, and we can finally say: **all three circles are complete.**

We have missiles. They home. They detonate. They're terrifying.

Let me show you what we built.

## The Weapon Palette: Three Projectile Types

Starwards now has three distinct projectile types, each with its own tactical role:

### 1. CannonShell (Medium Range)

The basic ballistic round. Fast, direct-fire, small explosion.

**Specs:**
- Velocity: ~1000 m/s (varies by ship/weapon)
- Explosion radius: 100m
- Damage: 20 (direct hit)
- Heat generation: Moderate

**Tactical role:** Medium-range engagement. Requires leading the target (no homing). Rewards accuracy. Low ammo consumption.

This is your bread-and-butter weapon. Fire, lead the target, land hits, manage heat. Straightforward.

### 2. BlastCannonShell (Area Denial)

A specialized ballistic round with a much larger explosion but lower direct damage.

**Specs:**
- Velocity: ~800 m/s
- Explosion radius: 200m (double the standard shell)
- Damage: 5 (direct hit)
- Blast force: 5 (knocks ships around)
- Heat generation: High

**Tactical role:** Area denial and disruption. You're not trying to kill with these—you're trying to knock enemies off course, disrupt formations, or force them into unfavorable positions.

Fire a spread of blast shells ahead of an enemy formation and watch them scatter. Or use them to "herd" an enemy into your chainguns' kill zone.

The blast force is the key feature here. Ships caught in the explosion get pushed by the shockwave. It's disruptive, it's chaotic, and it's *fun*.

### 3. Missile (Long Range)

And now we get to the star of the show: the **homing missile**.

**Specs:**
- Velocity: 600 m/s (slower than shells, but it turns)
- Rotation capacity: 720°/s (it can spin and track)
- Explosion radius: 1000m (massive)
- Damage: 50 (devastating)
- Proximity detonation: 100m trigger radius
- Flight time: 60 seconds (then self-destructs)

**Tactical role:** Long-range assassination. Fire-and-maneuver. Alpha strikes.

This is a smart munition. It thinks.

## Homing Mechanics: Making Missiles Think

The most interesting part of missiles is the homing algorithm. We wanted missiles that felt *intelligent*—they pursue their target, adjust trajectory, and detonate at the right moment.

Here's how it works:

### Target Acquisition

When a missile launches, it's assigned a `targetId`. This is locked in at launch—the missile doesn't retarget mid-flight (at least not yet).

Every frame, the missile checks: Is my target still alive? Is it in range?

If yes, pursue. If no, continue on ballistic trajectory (or self-destruct after 60 seconds).

### Course Correction

The missile calculates the angle to its target:

```typescript
const dx = target.x - missile.x;
const dy = target.y - missile.y;
const targetAngle = Math.atan2(dy, dx);
```

Then it compares that to its current heading and rotates toward the target, limited by its rotation capacity:

```typescript
const angleDiff = normalizeAngle(targetAngle - missile.angle);
const maxRotation = rotationCapacity * dt; // 720°/s × deltaTime

missile.angle += Math.sign(angleDiff) * Math.min(Math.abs(angleDiff), maxRotation);
```

The missile can turn at 720°/s, which means it takes about 0.5 seconds to make a full 180° turn. This is fast enough to be threatening but slow enough that you can *outmaneuver* it if you're agile.

### Velocity Adjustment

As the missile turns, it also adjusts its velocity vector to align with its new heading:

```typescript
missile.vx = Math.cos(missile.angle) * missile.speed;
missile.vy = Math.sin(missile.angle) * missile.speed;
```

This creates a smooth, arcing pursuit. The missile doesn't snap to the target—it curves through space, following a pursuit curve like a real-world guided munition.

If you've ever watched footage of a Sidewinder missile tracking an aircraft, you'll recognize the behavior. It's not perfect interception calculus (we're not doing proportional navigation yet), but it's convincing and dangerous.

### Proximity Detonation

Here's the clever bit: missiles don't need to hit you directly.

Every frame, the missile checks the distance to its target:

```typescript
const dist = Math.hypot(target.x - missile.x, target.y - missile.y);

if (dist < proximityRadius) {
  this.detonate();
}
```

If the target is within 100m, the missile detonates. This means:

1. **Near-misses count.** You don't have to nail a direct hit—getting close is enough.
2. **Evasion is possible.** If you're fast and maneuvering hard, you can make the missile overshoot, circle back, waste fuel.
3. **Point defense matters.** If you can shoot down the missile before it gets within 100m, you're safe.

It creates counterplay. Missiles are scary, but they're not guaranteed kills.

## Explosion Physics: Blast Damage and Force

When a projectile detonates (either on impact or via proximity trigger), it creates an **Explosion** object.

Explosions aren't just visual effects—they're physical entities with gameplay consequences.

### Expansion and Duration

An explosion has:
- `radius`: Maximum size (e.g., 1000m for missiles)
- `expansionSpeed`: How fast it grows
- `secondsToLive`: How long it exists (typically ~2 seconds)

The explosion expands from a point, growing at `expansionSpeed` until it reaches full `radius`, then fades out.

### Damage Falloff

Any ship or object within the explosion radius takes damage, but the amount depends on distance:

```typescript
const dist = Math.hypot(ship.x - explosion.x, ship.y - explosion.y);
const distFactor = 1 - (dist / explosion.radius);
const damage = explosion.damageFactor * (distFactor * distFactor); // Inverse-square falloff
```

The `distFactor` is linear (0 at the edge, 1 at the center), but we square it to get inverse-square falloff. This matches real-world blast physics—standing twice as far from an explosion doesn't halve the damage, it *quarters* it.

So a missile with `damageFactor = 50` and `radius = 1000m` deals:
- At center (0m): 50 damage
- At 500m: 50 × (0.5)² = 12.5 damage
- At 707m: 50 × (0.293)² = 4.3 damage
- At 1000m: 0 damage

This creates a deadly kill zone in the center and a "danger zone" further out. Close hits are devastating. Distant hits still hurt but aren't fatal.

### Blast Force

Explosions also apply an impulse—a sudden push—to nearby objects:

```typescript
const blastForce = explosion.blastFactor * distFactor;
const angle = Math.atan2(ship.y - explosion.y, ship.x - explosion.x);

ship.vx += Math.cos(angle) * blastForce;
ship.vy += Math.sin(angle) * blastForce;
```

The force is proportional to `blastFactor` and falls off linearly with distance. Ships closer to the explosion get shoved harder.

This creates chaos. A missile detonating in the middle of a furball sends ships spinning in all directions. Blast shells knock people off course. Even if the damage doesn't kill you, the disruption might.

## The Torpedo Tube System: Limited Ammo

Missiles aren't unlimited. You can't just spam them. You have to *load* them, *fire* them, and eventually *run out*.

This is handled by two components:

### Magazine (`magazine.ts`)

Your ship has a magazine with finite ammunition:

```typescript
class Magazine {
  @gameField() capacity: number = 10; // Max ammo
  @gameField() missiles: number = 10; // Current count
}
```

Fire a missile, `missiles` decrements. Run out, you're dry. You need to dock with a station or supply ship to reload.

### Torpedo Tubes (`tube.ts`)

Each ship has one or more torpedo tubes. Each tube has:
- `angle`: Which direction it fires (forward, broadside, aft)
- `loaded`: Is there a missile ready to fire?
- `loading`: Are we currently loading?
- `loadTimeFactor`: How fast the reload is (affected by crew efficiency, damage, etc.)

When you fire, the tube ejects the loaded missile. Then it begins loading the next one. Loading time is typically 5-10 seconds, modified by `loadTimeFactor`.

If your magazine is empty, loading fails. The tube stays empty until you resupply.

This creates resource management. You have, say, 10 missiles for the whole engagement. Do you:
- Fire them all in the opening salvo for maximum alpha strike?
- Save them for critical targets?
- Use them to force enemies to maneuver while your chainguns do the real damage?

It's a tactical decision. And it makes the weapons officer's job more interesting.

## Tactical Implications: The Three Circles in Action

Now that we have all three weapon types, here's what a typical engagement looks like:

**Opening (4000m+):**
- You fire missiles at long range. The enemy sees them coming, starts maneuvering.
- They're forced to evade or shoot them down, disrupting their formation.
- You use this chaos to close distance or reposition.

**Medium range (1000-4000m):**
- Missiles are still in flight, still a threat.
- You open up with cannon shells. Leading targets, firing in bursts, managing heat.
- Maybe you mix in blast shells to disrupt their evasion, push them into your missiles' path.

**Close range (0-1000m):**
- The furball. Chainguns screaming. Ships at knife-fighting range.
- Missiles are too slow here—they'll overshoot or hit your own ships.
- It's all about gunnery, maneuvering, and heat management.

Each range has its own feel. Long range is chess. Medium range is skirmish. Close range is knife fight.

And the transitions between ranges *matter*. You're constantly thinking: "Do I close to chaingun range, or keep them at arm's length with missiles?"

## The LARP Experience: Coordination Under Fire

From a LARP perspective, missiles make the weapons officer role *so much more interesting*.

Before missiles, the weapons officer just held down the chaingun trigger and watched heat. Simple, but shallow.

Now:
- They're tracking missile flight times and proximity
- Calling out "Missile away!" when they fire
- Requesting resupply when the magazine runs low
- Coordinating with the pilot: "Keep them at 3000m, I need time for the missiles to track"
- Watching tubes reload: "Tube 1 loaded, tube 2 loading, 8 seconds"

It's *involved*. It's *engaging*. It creates radio chatter.

And when a missile scores a proximity detonation and you see the explosion light up the tactical display? *Chef's kiss.*

## What's Next: CIWS and Point Defense

We have the missiles. The next step is the countermeasure: **point defense systems**.

In real-world naval combat, you have CIWS (Close-In Weapon Systems)—rapid-fire autocannons designed to shoot down incoming missiles. We mentioned this back in the original Engagement Circles post, showing videos of the Phalanx CIWS.

Starwards needs the same thing. A weapon mode that:
- Automatically targets incoming missiles (not ships)
- Fires in rapid bursts
- Has limited range (1000m or so)
- Requires power and coolant (of course)

This creates the full missile/counter-missile game. You fire missiles. They activate point defense. Maybe some missiles get through. Maybe none do. Maybe you fire *enough* missiles to overwhelm their point defense.

It's the long-range engagement circle finally complete.

## The Promise Kept

Four years ago, we drew three circles on a diagram and said "this is how space combat should work."

Now, finally, all three circles exist. Long range, medium range, close range. Missiles, shells, chainguns. Smart munitions, ballistic fire, rapid engagement.

And it *works*. It feels tactical. It feels deep. It rewards planning, positioning, and coordination.

The engagement circles are complete.

---

**Next in this series:** "Armor Reborn: From Design to Reality" — where we take the sectional armor system we designed in 2021 and show you how it actually works now that it's fully implemented.
