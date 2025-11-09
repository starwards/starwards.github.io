---
layout: post
title: "Engineering Complete: Energy, Heat, and System Effectiveness"
subtitle: The interconnected web of ship systems we promised four years ago
tags: [product, technology, game-design, stations]
---

Remember way back in March 2021 when we announced "Moving to the second milestone"? We'd just finished the dogfight milestone (ships can fly and shoot) and declared that the next focus would be engineering content.

We promised: energy management, heat distribution, system effectiveness, damage propagation. The stuff that would make the engineer station actually interesting to play.

Then we talked about it. Designed it. Showed diagrams. And... didn't implement it. Not really. Not completely.

Until now.

As of the 2024 rewrite, Starwards has a complete, fully functional engineering system. Energy flows from reactors through power distribution. Heat accumulates from system usage and dissipates through coolant. And every single ship system has an effectiveness rating that depends on power, heat, and damage state.

It's the interconnected web we promised. And it's glorious.

## The Vision: Living, Breathing Ships

The goal was never just to have an "energy meter." Any game can do that. The goal was to make ships feel like *organisms*—complex systems where everything affects everything else.

If you run your weapons hot, you need more coolant. If you divert coolant to weapons, your thrusters overheat. If your reactor gets damaged, you can't power all systems at full capacity. If you shut down non-essential systems, you free up power for shields.

Every decision should have consequences. Every system should matter. And the engineer should be constantly making trade-offs, not just clicking "repair."

That was the vision. Here's how we implemented it.

## Energy Flow: From Reactor to Systems

Let's start with the simplest question: Where does energy come from?

Answer: **The reactor.**

Every ship has a reactor (or multiple reactors, potentially). The reactor has an `energy` output rating—let's say 1000 units for a fighter. That's the total power budget.

But here's the first layer of complexity: the reactor also has an `efficiencyFactor`. This represents damage, maintenance state, fuel quality, whatever narrative you want. If your reactor is at 80% efficiency, your actual power output is:

```
totalPower = reactor.energy × reactor.efficiencyFactor
```

So a 1000-unit reactor at 80% efficiency produces 800 units of usable power.

Now, where does that power go?

## Power Allocation: The Balancing Act

Every system on your ship consumes power. Your thrusters, weapons, radar, shields (if you have them), life support, sensors—everything.

Each system has a `power` setting, typically ranging from 0 (SHUTDOWN) to 1.0 (MAXIMUM). This isn't the power it *consumes*—it's the power it *requests*.

Here's the key insight: **Systems don't automatically get the power they request.**

The `energy-manager.ts` looks at all the power requests and compares them to the available power budget. If you have 800 units available and systems are requesting 1000 units total, you've got a brown-out situation.

What happens? The energy manager scales down *all* systems proportionally.

Let's say:
- Thrusters request 300 units (power setting: 1.0)
- Weapons request 400 units (power setting: 1.0)
- Radar requests 200 units (power setting: 1.0)
- Life support requests 100 units (power setting: 0.5)

Total demand: 1000 units. Available: 800 units.

The scaling factor is `800 / 1000 = 0.8`. So every system gets 80% of what it requested:
- Thrusters receive 240 units
- Weapons receive 320 units
- Radar receives 160 units
- Life support receives 80 units

Your ship is now operating at reduced capacity across the board. The lights are dimmer (narratively speaking). Systems are sluggish. This is the price of running a damaged reactor at full load.

The engineer's job is to manage this. Shut down non-essential systems. Redistribute power. Prioritize what matters.

If you're in combat, maybe you shut down long-range sensors and route that power to weapons. If you're running from a fight, maybe you shut down weapons entirely and push everything to thrusters.

This is the engineering gameplay we wanted.

## Heat: The Other Half of the Equation

But energy is only half the story. The other half is **heat**.

In space, heat management is a real problem. You can't cool something by convection (there's no air). You're relying on radiators, coolant loops, and eventually just radiating heat into space (which is slow).

Every system in Starwards generates heat when it's used. Especially weapons and thrusters. And if a system gets too hot, bad things happen.

### Heat Accumulation

Each system tracks its current `heat` level (0-100+). Heat accumulates based on usage:

```
heat += usageHeat × deltaTime
```

Fire your chainguns continuously? Heat goes up. Run your thrusters at full burn? Heat goes up. Charge your warp drive? Heat goes up.

Different systems generate heat at different rates. Weapons are hot. Thrusters are very hot. Radar? Not so much.

### Heat Dissipation

Heat doesn't just sit there forever. Systems cool down via coolant distribution:

```
heat -= (coolantFactor × coolantPerFactor) × deltaTime
```

The `coolantFactor` is how much of the ship's total coolant capacity is allocated to this system. The `coolantPerFactor` is how effective that coolant is (based on the coolant system's own health and power).

Just like with energy, coolant is a limited resource that must be allocated. The `heat-manager.ts` distributes coolant across all systems, and you can adjust the distribution.

Do you route more coolant to weapons so you can fire longer bursts? Or to thrusters so you can afterburn without overheating? Or do you balance it evenly and accept that everything will run a bit hotter?

### Overheat Damage

Here's where it gets dangerous: if a system's heat exceeds 100, it breaks.

```
if (heat > 100) {
  broken = true
}
```

Dead simple, right? Overheat your chainguns, they seize up. Overheat your thrusters, they fail. Now you're drifting.

A broken system outputs zero effectiveness (more on that in a moment) until it's repaired. And repairs take time.

This creates tactical pressure. You *can* push systems beyond their limits for short bursts—but you're gambling. Can you kill the enemy before your weapons overheat? Can you escape before your thrusters burn out?

The engineer needs to watch those heat levels and manage coolant actively.

## The Effectiveness Formula: Bringing It All Together

Now we get to the heart of the system: **effectiveness**.

Every system in the game has an effectiveness rating that determines how well it works. This isn't a hidden stat—it's calculated in real-time based on three factors:

```typescript
effectiveness = broken ? 0 : power × coolantFactor × (1 - hacked)
```

Let's break that down:

1. **Broken:** If the system is broken (from damage or overheat), effectiveness is zero. It doesn't matter how much power or coolant you have—it's offline.

2. **Power:** This is the actual power the system is receiving (after energy manager scaling). If you're getting 80% of requested power, this is 0.8.

3. **CoolantFactor:** This is how well-cooled the system is. If it's running hot but not broken, the coolant factor drops below 1.0, reducing effectiveness.

4. **Hacked:** This is for cyber warfare (not fully implemented yet, but the hooks are there). If an enemy hacker has compromised your system, `hacked` represents how much control they have.

So a thruster at full power (1.0), well-cooled (coolant factor 1.0), and not hacked (0) has effectiveness of:

```
effectiveness = 1.0 × 1.0 × (1 - 0) = 1.0
```

Perfect performance.

But if that same thruster is:
- Receiving only 80% power (brown-out)
- Running hot with coolant factor 0.7
- Not hacked

Its effectiveness is:

```
effectiveness = 0.8 × 0.7 × 1.0 = 0.56
```

It's operating at 56% capacity. Your ship is slower. Your turns are sluggish. You can feel the difference.

## The Interconnected Web

Here's where it gets beautiful: **everything affects everything**.

- Low reactor output → brown-out → low power to thrusters → low thruster effectiveness → slower ship
- Heavy weapon usage → high heat → needs more coolant → less coolant for other systems → other systems run hotter
- Damaged coolant system → reduced coolant effectiveness → all systems run hotter → risk of overheats across the board
- Engineer shuts down weapons → frees up power → more power to thrusters → ship accelerates → but now defenseless
- Afterburner usage → massive heat spike in thrusters → emergency coolant divert → weapons overheat → chainguns seize

It's a living system. A web of dependencies and trade-offs. And it makes the engineer role *matter*.

## What This Means for LARP

From a LARP perspective, this system delivers on the promise of role differentiation.

The **pilot** flies the ship, but they feel the consequences of engineering decisions. Sluggish controls mean power is low or thrusters are overheating. They need to communicate with the engineer.

The **weapons officer** fires the guns, but they're watching heat levels. They need to time their bursts, manage their trigger discipline, call out when they're overheating. They're coordinating with the engineer on coolant allocation.

The **engineer** is the maestro of this orchestra. They're watching power distribution, coolant flow, heat levels across all systems. They're making calls: "Shutting down radar, routing power to thrusters." "Weapons are at 90% heat, ease off!" "Reactor's damaged, we're at 70% power budget, I need you to prioritize."

It creates *conversation*. It creates *dependency*. It creates the feeling of running a ship together.

And that's the whole point.

## The Code: A Peek Under the Hood

If you're curious how this is actually implemented, here's a simplified look at the effectiveness calculation from the codebase:

```typescript
@defectible()
class System extends GameObject {
  @gameField() power: number = 1.0;
  @gameField() heat: number = 0;
  @gameField() broken: boolean = false;
  @gameField() hacked: number = 0;

  coolantFactor: number = 1.0; // Set by heat manager

  get effectiveness(): number {
    if (this.broken) return 0;

    return this.power × this.coolantFactor × (1 - this.hacked);
  }

  update(dt: number) {
    // Heat accumulation
    this.heat += this.calculateUsageHeat() * dt;

    // Heat dissipation
    this.heat -= (this.coolantFactor × this.coolantPerFactor) * dt;

    // Overheat check
    if (this.heat > 100) {
      this.broken = true;
    }
  }
}
```

That `@defectible()` decorator? That integrates the system with the malfunction system (generating engineering problems for the crew to solve). The `@gameField()` decorators sync state across the network via Colyseus.

But the core logic is simple: accumulate heat, dissipate heat, check for overheat, calculate effectiveness.

Simple rules, complex behavior.

## What's Still Missing

This system is complete, but there are still features we want to add:

**Capacitors:** Some systems (like shields or jump drives) might want burst power beyond the reactor's continuous output. Capacitors would charge slowly and discharge quickly.

**Redundancy:** Multiple reactors, automatic failover, isolated power buses. Right now, one reactor failure browns out your whole ship.

**Repair Complexity:** Currently, repairs just set `broken = false` after a timer. We want repair minigames, replacement parts, field repairs vs. dockyard repairs.

**Fuel:** The reactor has infinite fuel right now. We want fuel management, refueling, reactor efficiency based on fuel type.

But the foundation is there. And it's solid.

## The Promise Delivered

Four years ago, we said we'd build an engineering system that mattered. We said we'd make ships feel like complex, interconnected organisms where every system depends on every other system.

We said the engineer would have real decisions to make, not just "click repair."

And now, finally, we can say: **we delivered.**

The engineering system is done. Energy flows. Heat dissipates (or doesn't). Systems have effectiveness that varies in real-time based on power, cooling, and damage.

It works. It's fun. And it's ready for you to play with.

---

**Next in this series:** "Missiles, Torpedoes, and Big Explosions" — where we complete the engagement circles vision with homing munitions that actually think.
