---
layout: post
title: "Armor Reborn: From Design to Reality"
subtitle: The sectional armor system we designed three years ago is finally real
tags: [product, damage, design, technology]
---

In April 2021, we published "Designing a Damage System." It was one of our more ambitious design posts—we laid out a complete vision for how damage should work in Starwards, inspired heavily by Battletech's sectional armor.

We showed diagrams. We explained hit location tables. We talked about armor penetration, breach mechanics, and internal system damage. We were excited.

And then... we didn't implement it. Not fully. Not correctly.

We had a basic version working—armor plates existed, they could take damage—but the math was wrong. The hit angle calculations were off. Penetration didn't work right. It was a prototype that *looked* like the system we designed but didn't *behave* like it.

Fast forward to April 2024. Pull requests [#1696](https://github.com/starwards/starwards/pull/1696) and [#1733](https://github.com/starwards/starwards/pull/1733). "Fix armor measurement logic." "Correct damage calculation formulas."

The armor system was finally, *actually* implemented.

And it works beautifully.

## The Vision: Battletech in Space

Let's start with the inspiration. If you've played Battletech (the tabletop game, not the video game), you know the armor system:

Your mech has armor plates on different locations: head, torso (front and back), arms, legs. Each plate has a certain number of armor points. When you get hit, you roll on a hit location table to determine *where* you got hit, then that specific armor plate takes damage.

Once a plate is destroyed, hits to that location penetrate through to the internal structure and critical components. Your left arm armor is gone? The next hit might destroy the actuator, the weapon mount, the whole limb.

This creates tactical depth:
- Positioning matters (don't show your damaged side)
- Armor distribution matters (do you front-load armor or balance it?)
- Focus fire matters (concentrate on one location to break through)

We wanted that same tactical depth in Starwards, but translated to a 2D space game.

## The Implementation: Directional Armor Plates

In Starwards, ships have **directional armor plates**. A typical fighter might have:
- Front plate (facing 0°)
- Right plate (facing 90°)
- Rear plate (facing 180°)
- Left plate (facing 270°)

Larger ships might have more granular divisions—front-right, front-left, aft-right, aft-left, etc. It's configurable per ship class.

Each plate has:
- **Health:** Current armor integrity (0 = destroyed)
- **Max health:** Starting armor value
- **Angle:** Which direction it faces (relative to ship heading)

When a projectile hits the ship, we need to determine *which plate got hit*.

### Hit Angle Calculation

This is where the math gets interesting.

First, we calculate the impact vector—the direction the projectile was traveling when it hit:

```typescript
const impactAngle = Math.atan2(projectile.vy, projectile.vx);
```

Then we calculate the relative angle to the ship:

```typescript
const relativeAngle = normalizeAngle(impactAngle - ship.angle);
```

`normalizeAngle` wraps the result to [-π, π] so we have a consistent range.

Now we have the angle of impact relative to the ship's facing. If `relativeAngle` is ~0°, the ship was hit from the front. If ~180°, from the rear. If ~90°, from the right side.

Next, we find the armor plate that's *closest* to that impact angle:

```typescript
let closestPlate = null;
let smallestDiff = Infinity;

for (const plate of ship.armor.plates) {
  const diff = Math.abs(normalizeAngle(relativeAngle - plate.angle));

  if (diff < smallestDiff) {
    smallestDiff = diff;
    closestPlate = plate;
  }
}
```

The plate whose angle is closest to the impact angle takes the hit.

Simple concept, but getting the angle math right was *not* simple. We had bugs where hits from the front would damage the rear plate. We had bugs where grazing shots counted as direct hits. We had bugs where armor plates covered angles they shouldn't.

Pull request #1696 fixed the angle calculation logic. We added comprehensive tests. We validated against known scenarios. And finally, it worked correctly.

### Penetration and Breach

Once we know which plate got hit, we apply damage:

```typescript
plate.health -= damage;

if (plate.health <= 0) {
  plate.health = 0;
  // Plate destroyed—breach!
}
```

When a plate reaches zero health, it's destroyed. The armor is breached at that location.

What happens on the next hit to that location?

The shot penetrates through to **internal systems**.

The `damage-manager.ts` routes penetrating damage to the systems behind the destroyed plate. This might be:
- The reactor (if hit from a specific angle)
- Thrusters (if hit from the rear)
- Weapons (if hit from the sides)
- The bridge (if hit from the front)

The exact mapping depends on ship design, but the concept is consistent: **breach the armor, damage the internals**.

This creates a cascading failure mode. Lose your rear armor? Enemy focuses fire there. Your aft thrusters get damaged. You lose reverse thrust. You can't back out of combat. You're committed.

Lose your front armor? Your bridge systems take hits. Sensors go down. Targeting fails. You're flying blind.

It's brutal, and it's *exactly* what we wanted.

### Damage Visualization

From a LARP perspective, the armor system only matters if the crew can *see* what's happening.

We built an **armor widget** that displays all armor plates visually:

```
    [Front: 80/100]
         ▲
[Left: 60/100] [Ship] [Right: 40/100]
         ▼
    [Rear: 20/100]
```

(Obviously the real UI is graphical, not ASCII, but you get the idea.)

Each plate shows:
- Current health
- Max health
- Color-coded status (green = healthy, yellow = damaged, red = critical, black = destroyed)

The damage control officer (or engineer, depending on your station setup) watches this display and calls out damage:

> "Armor breach, starboard side! Internal damage likely on next hit!"

> "Front plate at 30%, recommend evasive maneuver!"

> "Rear armor critical, do NOT show them our tail!"

This is the LARP magic. The armor system creates *information* that players must communicate and react to.

## Tactical Implications: Angling Matters

Here's where it gets fun: **positioning and facing matter**.

If your front armor is thick (100 health) and your rear armor is thin (40 health), you want to:
1. Face your enemies (present the strong armor)
2. Avoid getting flanked (protect the weak armor)
3. Maneuver to prevent enemies from getting behind you

Conversely, if you're attacking:
1. Try to hit their weak side (flank them)
2. Focus fire on damaged plates (finish the breach)
3. Once armor is breached, keep hitting that spot (damage internals)

This creates a dance. You're trying to angle your ship to take hits on your strong armor while maneuvering to hit the enemy's weak armor.

It's not just "fly forward and shoot." It's positional combat. It's *tactical*.

### Armor Distribution Choices

Different ship designs have different armor distributions:

**Tank:** Heavy front armor, light rear. Designed to face enemies head-on. Vulnerable if flanked.

**Balanced:** Equal armor all around. No weak spots, but no strong points either. Jack-of-all-trades.

**Evasion Fighter:** Light armor everywhere, relies on speed and maneuverability to avoid hits rather than tanking them.

**Broadside Cruiser:** Heavy side armor, light front/rear. Designed to present its side (where the main guns are) while staying armored.

These aren't just flavor—they're strategic choices with gameplay consequences.

## The Bugs We Fixed

Let's be honest: the first implementation was broken.

### Bug 1: Incorrect Plate Angle Mapping

Originally, we calculated the hit plate based on absolute angles instead of relative angles. This meant that a ship rotated 90° would assign hits to the wrong plates.

The fix was switching to relative angle calculation (impact angle minus ship angle) and normalizing properly.

### Bug 2: Penetration Damage Not Routing

When a plate was destroyed, penetrating damage wasn't being routed to internal systems. The plate would show "breached," but the ship's internals were unaffected.

We added the penetration routing logic in `damage-manager.ts` to propagate damage through breached plates.

### Bug 3: Armor Measurement Edge Cases

There were edge cases where damage would "wrap around" at the -π/π boundary (the discontinuity at the back of the ship where angles flip from 179° to -179°).

We fixed this by consistently using `normalizeAngle` and accounting for the wrap-around in our angle difference calculations.

### Testing, Testing, Testing

Pull request #1733 added comprehensive tests:
- Known hit scenarios (front hit, rear hit, side hit)
- Angle edge cases (wrapping, negative angles)
- Penetration mechanics (does damage route correctly?)
- Multi-plate ships (do complex armor layouts work?)

We validated the math. We proved the formulas. And finally, the armor system worked *correctly*.

## The LARP Experience: Damage Control

With the armor system fully implemented, the damage control role becomes engaging:

**Before combat:**
- Review armor status (all plates healthy?)
- Check repair supplies (do we have materials?)
- Coordinate with captain on tactical approach (which side do we show?)

**During combat:**
- Monitor armor status display
- Call out damage as it happens
- Prioritize repair orders (fix critical plates first)
- Advise captain on positioning ("Don't show them our port side, it's breached!")

**After combat:**
- Assess total damage (which plates need repair?)
- Allocate repair resources (limited repair bots, limited materials)
- Report readiness to captain

It's a mini-game within the game. And it's *satisfying* when you successfully manage damage, keep the ship alive, and limp home with one plate at 5 health.

## What's Next: Advanced Damage

The armor system is complete, but there's room to grow:

**Ablative Armor:** Plates that regenerate slowly over time (representing self-sealing materials).

**Reactive Armor:** Plates that reduce damage from the first hit but are consumed in the process.

**Armor Hardening:** Temporary buffs that increase a specific plate's health (representing angle changes, polarization, etc.).

**Critical Hits:** When a penetrating hit strikes an internal system, a chance for catastrophic damage (reactor breach, magazine detonation, etc.).

**Field Repairs:** Patch jobs that restore some armor but not full strength. Proper repairs require docking.

But the foundation is solid. The core mechanic works. And it's been worth the wait.

## The Promise Delivered

Three years ago, we designed a sectional armor system inspired by Battletech. We promised that positioning would matter, that damage would be localized, that armor breaches would have consequences.

And now, after two pull requests, extensive testing, and a lot of angle math, we can say:

**The armor system we designed in 2021 is now real.**

It works. It's tactical. It creates LARP moments. And every time someone calls out "Armor breach on the starboard quarter!" we smile, because that's exactly what we wanted.

---

**Next in this series:** "Bots, Autopilots, and AI Commanders" — where we go from the spiral bug of 2022 to a full AI framework with tactical orders and idle behaviors.
