---
layout: post
title: "The Developer Experience Revolution"
subtitle: From closed codebase to welcoming platform
tags: [technology, product]
---

In June 2022, we published a post titled "Starwards is now open-source." We were excited—we'd made the repository public, committed to open development, and invited contributions.

But in that same post, we admitted:

> "it's still showing signs of being a closed project"

We knew the codebase was intimidating. The documentation was minimal. The architecture was opaque. The testing infrastructure was... well, there wasn't much of one.

We'd opened the gates, but we hadn't made the castle welcoming.

Fast forward to 2024. We have:
- **10+ comprehensive documentation files** covering architecture, systems, patterns, and APIs
- **Extensive testing infrastructure** with Playwright E2E tests and test harnesses
- **Enhanced decorators** that make the codebase self-documenting
- **GM tools** with a tweak UI for real-time debugging
- **Node-RED integration** for external scripting and automation

We didn't just open-source Starwards. We made it *approachable*.

And that's the difference between a public repository and an actual community project.

## The Documentation Effort: Making Knowledge Accessible

Let's be honest: our documentation in 2022 was a README and some scattered comments. If you wanted to understand how the game worked, you had to read the source code.

That's not sustainable. It's not welcoming. And it's not respectful of contributors' time.

So we wrote documentation. A lot of it.

### The Documentation Suite

Here's what we created:

**ARCHITECTURE.md** — System design and data flow
- How Colyseus room architecture works (SpaceRoom, ShipRoom, AdminRoom)
- State synchronization patterns
- Client-server communication
- Entity lifecycle

**SUBSYSTEMS.md** — Ship systems reference
- Complete catalog of ship systems (reactor, thrusters, weapons, radar, etc.)
- Properties and how they interact
- Effectiveness calculations
- Damage and malfunction mechanics

**PHYSICS.md** — Physics engine details
- Movement and rotation
- Collision detection (spatial hashing, raycasts)
- Explosion propagation
- Impulse-based response

**PATTERNS.md** — Code conventions and gotchas
- Decorator usage patterns
- Common pitfalls (MapSchema iteration, memory leaks)
- Best practices for extending the codebase
- Code style guide

**TECHNICAL_REFERENCE.md** — Decorators, build tools
- Complete decorator reference (`@gameField`, `@tweakable`, `@range`, `@defectible`)
- Build system explanation (Vite, TypeScript, Colyseus)
- Development workflow
- Debugging tools

**API_REFERENCE.md** — Commands, events
- JSON Pointer command system
- Event subscription patterns
- GM commands API
- Scripting interface

**LLM_CONTEXT.md** — AI assistant guide
- How to use Claude Code with Starwards
- Project structure overview
- Common tasks and patterns
- Context for AI pair programming

**testing/README.md** — Testing guide
- How to write tests
- Test harness usage
- Playwright E2E patterns
- Snapshot testing

**testing/UTILITIES.md** — Test tools reference
- ShipTestHarness API
- Multi-client driver
- Factory functions
- Test scenarios

**INTEGRATION.md** — Node-RED integration
- Custom node documentation
- Flow examples
- API exposure
- Event streaming

### The Philosophy: Documentation is Code

We adopted a philosophy: **documentation is not a separate task—it's part of the implementation**.

When you implement a new system, you document it. Not later, not "when we have time," but *as part of the PR*.

This means:
- New systems come with documentation
- Complex patterns are explained in PATTERNS.md
- API changes update API_REFERENCE.md
- Test utilities are documented in UTILITIES.md

The result: the documentation is accurate, up-to-date, and comprehensive.

If you want to understand how energy management works, you don't have to reverse-engineer `energy-manager.ts`—you read SUBSYSTEMS.md, which explains the concept, then you look at the code for implementation details.

## Testing Infrastructure: From Minimal to Comprehensive

In 2022, we had some unit tests. They were brittle, incomplete, and rarely run.

In 2024, we have:
- **End-to-end tests** using Playwright
- **Test harnesses** for ship simulation
- **Snapshot testing** for UI regression
- **Multi-client tests** for networking scenarios
- **Integration tests** for complex behaviors

### The ShipTestHarness

The `ShipTestHarness` is a utility class that makes testing ship systems trivial:

```typescript
const harness = new ShipTestHarness();
const ship = harness.createTestShip('fighter');

// Simulate time passing
harness.advance(10); // 10 seconds

// Assert conditions
expect(ship.reactor.effectiveness).toBeGreaterThan(0.8);
expect(ship.thrusters.heat).toBeLessThan(50);
```

The harness handles:
- Room setup (creating a test Colyseus room)
- Ship creation (with configurable ship types)
- Time advancement (simulating game ticks)
- State inspection (checking system states)
- Cleanup (tearing down rooms after tests)

This makes it easy to write tests for complex scenarios:

```typescript
test('Overheating thrusters reduces effectiveness', async () => {
  const harness = new ShipTestHarness();
  const ship = harness.createTestShip('fighter');

  // Run thrusters at max with no coolant
  ship.pilot.boost = 1.0;
  ship.heatManager.setCoolant('thrusters', 0);

  // Advance time until overheat
  harness.advanceUntil(() => ship.thrusters.heat > 100, 60);

  // Verify thruster is broken
  expect(ship.thrusters.broken).toBe(true);
  expect(ship.thrusters.effectiveness).toBe(0);
});
```

This is readable, maintainable, and actually runs.

### Playwright E2E Tests

For full-stack testing (client + server), we use Playwright:

```typescript
test('Player can join game and control ship', async ({ page }) => {
  await page.goto('http://localhost:4000');

  await page.click('text=Join Game');
  await page.click('text=Fighter-01');

  // Ship control is now visible
  await expect(page.locator('.helm-widget')).toBeVisible();

  // Apply thrust
  await page.keyboard.press('w');

  // Verify ship is moving
  const velocity = await page.locator('.velocity-display').textContent();
  expect(parseFloat(velocity)).toBeGreaterThan(0);
});
```

These tests validate:
- UI rendering
- User interactions
- Network synchronization
- Game logic integration

They catch regressions that unit tests miss.

### Test Coverage

We're not at 100% coverage (and probably never will be—some code is hard to test meaningfully). But we have coverage for:
- All core ship systems (reactor, thrusters, weapons, radar)
- Energy and heat management
- Damage and armor mechanics
- Autopilot and bot AI
- Explosion physics
- Docking mechanics

When we refactor, we run the tests. When tests fail, we know what broke. It's a safety net that makes development *faster*, not slower.

## Enhanced Decorators: Self-Documenting Code

TypeScript decorators are powerful, and we use them extensively:

### `@gameField()` — State Synchronization

Marks a property for Colyseus synchronization:

```typescript
class System {
  @gameField() power: number = 1.0;
  @gameField() heat: number = 0;
}
```

Any property marked with `@gameField()` is automatically synced from server to client. Change it on the server, clients see the update.

### `@tweakable()` — GM Debug UI

Marks a property for exposure in the tweak UI:

```typescript
class Reactor {
  @tweakable()
  @gameField() energy: number = 1000;
}
```

Any property marked with `@tweakable()` appears in the GM's tweak panel. You can adjust it in real-time while the game is running.

This is *invaluable* for balancing. Want to see how the game feels with 50% more reactor power? Tweak it live. No recompile, no restart.

### `@range(min, max)` — Value Constraints

Constrains a property to a range:

```typescript
class System {
  @range(0, 100)
  @tweakable()
  @gameField() heat: number = 0;
}
```

The `@range` decorator ensures `heat` never goes below 0 or above 100. If code tries to set it to 150, it's clamped to 100.

And because it's stacked with `@tweakable()`, the tweak UI shows a slider with min/max bounds. The UI is generated from the decorators—no manual UI code needed.

### `@defectible()` — Malfunction System

Marks a system as capable of having malfunctions:

```typescript
@defectible()
class Radar extends System {
  // ...
}
```

The `@defectible()` decorator integrates the system with the malfunction manager. When the radar takes damage, it can generate engineering problems (range flicker, ghost contacts, etc.).

The decorator pattern makes the integration declarative—you're marking intent, not wiring up boilerplate.

### Decorator Stacking Order

The decorators have a specific stacking order that matters:

```typescript
@range(0, 100)      // Innermost — applied first
@tweakable()        // Middle — reads range metadata
@gameField()        // Outermost — syncs the final value
heat: number = 0;
```

This is documented in TECHNICAL_REFERENCE.md, so contributors know the correct pattern.

## GM Tools: Tweak UI and Object Creation

The GM screen got a major upgrade:

### Tweak Panel

The tweak panel shows all `@tweakable()` properties for the selected ship:

- **Reactor:** energy, efficiencyFactor
- **Thrusters:** rotationSpeed, afterburnerBoost
- **Weapons:** damage, fireRate, heat
- **Armor:** plate health values

The GM can adjust any of these values live. Change thruster speed mid-flight and watch the ship respond. Set reactor efficiency to 0.1 and watch the ship brown-out.

This is a debugging tool, but it's also a storytelling tool. The GM can dynamically adjust difficulty, create failures, or test "what if" scenarios.

### Drag-and-Drop Entity Spawning

The GM can drag ship templates from a palette onto the map:
- Fighters, cruisers, stations
- Asteroids
- Waypoints

Click, drag, drop—entity spawns at that position. Instant scenario building.

Combined with bot AI (from Post 5), the GM can create complex encounters on the fly:
1. Spawn enemy ships
2. Right-click → "Attack player ship"
3. Engagement begins

No scripting required.

## Node-RED Integration: External Automation

This is one of the more experimental features, but it's incredibly powerful: **Node-RED integration**.

[Node-RED](https://nodered.org/) is a visual programming tool for wiring together APIs, services, and devices. We created custom Starwards nodes for Node-RED that expose the game's API.

### Use Cases

**Automated Scenarios:**
- When player enters zone → spawn enemies
- When ship health < 20% → trigger distress call
- Every 30 seconds → spawn new patrol ship

**External Dashboards:**
- Stream game state to a web dashboard
- Display ship positions on a map
- Show real-time engineering telemetry

**Integration with Other Systems:**
- Connect Starwards to Discord (announce events in chat)
- Log game events to a database
- Trigger IoT devices (flash lights when ship takes damage, for LARP immersion)

### Example Flow

A simple Node-RED flow:

```
[Starwards Event: Ship Created]
  → [Filter: Ship type = "enemy"]
  → [Delay: 5 seconds]
  → [Starwards Command: Issue Attack Order]
```

This flow automatically makes enemy ships attack the player 5 seconds after spawning. No code required—just visual wiring.

## What This Means for Contributors

All of these improvements have one goal: **make Starwards welcoming to contributors**.

If you want to:
- **Understand the codebase:** Read the documentation
- **Add a new system:** Follow the patterns, use decorators
- **Test your changes:** Use the test harnesses
- **Debug issues:** Use the tweak UI
- **Extend with scripts:** Use Node-RED or the scripts API

The barriers to entry are lower. The learning curve is gentler. The tools are better.

And that's how you build a community project.

## The Invitation

In 2022, we said Starwards was open-source.

In 2024, we can say: **Starwards is ready for contributors.**

The code is documented. The tests exist. The tools are there. If you want to build a LARP bridge simulator, or a space combat game, or an experimental multiplayer physics sandbox—Starwards is a platform you can actually work with.

We're not just inviting contributors. We're *welcoming* them.

---

**Next in this series:** "The Rewrite: Why We Started Fresh" — where we explain the decision to rebuild Starwards from the ground up in March 2024, and what we learned from the prototype years.
