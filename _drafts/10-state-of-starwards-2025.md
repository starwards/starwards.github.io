---
layout: post
title: "State of Starwards 2025: What's Next"
subtitle: Where we've been, where we are, and where we're going
tags: [product, story]
---

If you've been following this catch-up series, you now know everything that happened between June 2022 and November 2024.

You know about:
- The decision to remove 3D rendering
- The complete energy, heat, and coolant systems
- Missiles with homing and proximity detonation
- Sectional armor implementation
- Bot AI and autopilot frameworks
- Warp drives, waypoints, and docking
- Combat refinements and targeting systems
- The developer experience revolution
- The rewrite that rebuilt the foundation

That's a lot. And honestly, looking back at the list, we're kind of amazed we shipped all of it.

But this series isn't just about looking back. This final post is about looking *forward*.

Where are we now? What's still missing? What's the roadmap? And most importantly: **how can you join us?**

## Where We Are: Feature Complete... For Core Systems

As of November 2024, Starwards has reached a milestone we're calling "**core systems complete**."

This means:
- The fundamental ship systems are implemented and working
- The combat loop is complete (engagement circles, targeting, damage)
- The engineering gameplay is deep and interconnected
- The navigation and movement systems support missions beyond single-zone combat
- The developer infrastructure supports contributions and testing

You can:
- Run a ship with multiple crew members
- Engage in dogfights with meaningful tactical decisions
- Manage energy, heat, and coolant
- Navigate using warp and waypoints
- Dock with stations and other ships
- Control NPC ships with GM tools
- Extend the game with scripts and Node-RED flows

**This is playable.** You could run a LARP event with Starwards today.

But "playable" isn't the same as "complete."

## What's Still Missing

Let's be honest about what we *haven't* built yet:

### 1. Corvette-Class Ships

In the early blog posts (February 2021), we talked about fighters vs. corvettes. The idea was:
- **Fighters:** Small, single-crew or two-crew ships. Fast, fragile. You see the whole ship on one screen.
- **Corvettes:** Larger ships requiring 4-6 crew. Multiple stations, multiple systems, more complex coordination.

We have fighters. We don't have corvettes.

The architecture supports them (multi-crew, modular stations, etc.), but we haven't designed and implemented corvette-specific systems like:
- Multi-room layouts (bridge, engineering, weapons bay)
- Internal ship movement (crew walking between stations)
- More complex system layouts (redundant reactors, isolated power buses)

### 2. Multiple Bridges

Right now, Starwards is designed for one ship (or multiple ships, each with their own crew).

What we don't have is **multiple player-crewed ships in the same scenario**, each fully crewed.

The architecture supports it (each ship has its own ShipRoom), but we haven't tested or optimized for:
- 3 ships × 5 crew = 15 simultaneous players
- Inter-ship communication and coordination
- Fleet-level GM tools

This is a scaling challenge, not a fundamental limitation. But it's work we haven't done yet.

### 3. Advanced Damage Reports

We have damage (systems break, armor breaches, malfunctions). What we don't have is rich, narrative damage reporting.

The vision from the April 2021 damage system post was:
- Engineering problems with flavor text ("Coolant leak in starboard manifold")
- Repair mini-games or procedures ("Reroute power through auxiliary conduit")
- Damage report UI that feels like Star Trek's LCARS

Right now, damage is functional but dry. We want it to be immersive.

### 4. Cyber Warfare

The system effectiveness formula includes a `hacked` term:

```typescript
effectiveness = power × coolantFactor × (1 - hacked)
```

But we don't have hacking gameplay yet. The vision is:
- Dedicated hacker station (ops/comms)
- Intrusion minigames
- Countermeasures and firewalls
- Compromising enemy systems (reduce their effectiveness, steal data, trigger malfunctions)

The hooks are there. The gameplay isn't.

### 5. Stations and Bases

We have ships. We have waypoints. What we don't have is **persistent locations**.

Space stations, planetary bases, asteroid mining outposts—these should be entities you can dock with, interact with, and potentially attack or defend.

The docking system supports this, but we haven't built:
- Station entities with services (repair, resupply, mission board)
- Planetary locations with gravity wells
- Economic systems (buying ammo, selling salvage)

### 6. Campaigns and Persistence

Right now, Starwards is scenario-based. You load a map, play a mission, end the session.

What we don't have is **campaign mode**:
- Save your ship's state between sessions
- Persistent damage and resource management
- Multi-session story arcs
- Fleet management over time

The save/load system exists (you can save and load game state), but we haven't built the campaign layer on top of it.

### 7. Content and Balance

We have systems. What we don't have is:
- A library of ship designs (right now it's just "fighter" and "cruiser" templates)
- A catalog of weapons, engines, reactors with different stats
- Balanced scenarios and missions
- Tutorial content for new players

This is the "content creation" phase, which is less about code and more about design and playtesting.

## The Roadmap: What's Next

So where do we go from here?

### Near-Term (Next 3-6 Months)

**1. Corvette Implementation**
- Design corvette-class ship templates
- Multi-room layouts
- Test with 4-6 person crews
- Refine station-to-station coordination

**2. Content Creation**
- More ship designs (scout, interceptor, bomber, support)
- More weapon types (railguns, beam weapons, mines)
- Scenario library (patrol, escort, defense, assault)

**3. Advanced Damage Reports**
- Engineering problem flavor text
- Repair procedures (not just timers)
- Immersive damage UI

**4. Playtesting and Balance**
- Run regular playtests with different crew sizes
- Balance energy/heat/damage numbers
- Polish the LARP experience

### Mid-Term (6-12 Months)

**1. Cyber Warfare Gameplay**
- Hacker station implementation
- Intrusion mechanics
- Countermeasures and defenses

**2. Stations and Bases**
- Station entity types
- Docking services (repair, resupply)
- Economic interactions

**3. Multi-Bridge Scenarios**
- Fleet combat (multiple player ships)
- Inter-ship communication tools
- GM tools for managing multiple crews

**4. Tutorial and Onboarding**
- New player experience
- Interactive tutorials for each station
- Guided first mission

### Long-Term (12+ Months)

**1. Campaign Mode**
- Persistent ship state
- Multi-session arcs
- Fleet management

**2. Modding Support**
- Custom ship designs (JSON or visual editor)
- Custom scenarios
- Plugin system for new systems/mechanics

**3. Visual Polish**
- Better effects (explosions, warp, damage)
- UI themes and customization
- Accessibility improvements

**4. Community Content**
- Scenario sharing
- Ship design library
- Contributor spotlight

This roadmap isn't set in stone. Priorities might shift based on community feedback, playtesting results, or new ideas.

But this is the direction we're heading.

## How You Can Join

Here's the part where we ask: **Do you want to help build this?**

Starwards is open-source. It's documented. It's tested. And it's ready for contributors.

Here's how you can get involved:

### For Developers

**Contribute code:**
- Pick an issue from GitHub
- Read the documentation (ARCHITECTURE.md, PATTERNS.md)
- Submit a pull request

**Areas we need help with:**
- UI/UX improvements (React, PixiJS)
- Game balance and mechanics
- Testing and quality assurance
- Performance optimization

**Prerequisites:**
- TypeScript, Node.js
- Familiarity with Colyseus (or willingness to learn)
- Understanding of game development concepts

**Getting started:** Check out the repository at [github.com/starwards/starwards](https://github.com/starwards/starwards), read `CONTRIBUTING.md` (which we should write...), and join the Discord.

### For Designers

**Contribute content:**
- Design ship templates
- Create scenarios and missions
- Write damage report flavor text
- Design UI mockups

**Tools needed:**
- JSON editing (for ship designs)
- Creativity and game design sense
- Optional: graphic design for UI

**Getting started:** Reach out on Discord, share your ideas, and we'll help you get set up.

### For Playtesters

**Help us refine the experience:**
- Run playtests with your LARP group
- Report bugs and balance issues
- Give feedback on UX and gameplay

**Prerequisites:**
- A group of friends willing to test
- Patience with early-stage software
- Good communication skills for feedback

**Getting started:** Join the Discord, say "I want to playtest," and we'll coordinate.

### For LARP Organizers

**Use Starwards for your events:**
- Run it at conventions or game nights
- Customize scenarios for your story
- Share your experiences and feedback

**What you get:**
- A free, open-source bridge simulator
- Customizable to your needs
- Community support

**Getting started:** Download, install, run. We'll help you set it up.

### For Everyone Else

**Spread the word:**
- Star the GitHub repository
- Share blog posts
- Talk about Starwards in LARP/game dev communities
- Provide feedback and ideas

Every bit helps. Open-source projects thrive on community, and we're building that community now.

## The Vision: A Platform, Not Just a Game

Here's what we realized during the rewrite: Starwards isn't just a game. It's a **platform**.

It's a platform for:
- Building LARP bridge simulators
- Experimenting with multiplayer space combat
- Creating narrative-driven space adventures
- Teaching game development and networked systems
- Exploring cooperative gameplay and role differentiation

The core systems are general enough to support many different games. Maybe you want to build:
- A fully cooperative PvE experience (players vs. environment)
- A competitive PvP arena (ship vs. ship tournaments)
- A narrative adventure game (scripted story with space combat)
- An educational simulation (teach teamwork and systems thinking)

Starwards can be the foundation for all of these.

And that's the long-term vision: a thriving ecosystem of scenarios, ship designs, mods, and derivative works, all built on the Starwards platform.

## The Commitment: We're Not Going Silent Again

We learned our lesson. Two and a half years of silence was too long.

Here's our commitment:
- **Regular blog posts** — at least monthly updates on progress
- **Active Discord** — community discussions, support, coordination
- **Open development** — pull requests, issues, roadmap discussions in public
- **Playtesting sessions** — regular opportunities to play and give feedback

We're not just building Starwards in a cave anymore. We're building it *with you*.

## The Invitation

So here we are. November 2025. Four years since we started Starwards. Two and a half years since we went silent. Eight months since we started the rewrite.

We've built:
- A complete engineering system
- A full combat loop
- Navigation and logistics
- Developer infrastructure
- A solid foundation

We've learned:
- When to delete work (3D rendering)
- When to rebuild (the rewrite)
- How to document and test
- How to build for community

And now we're asking:

**Do you want to build this with us?**

If you've ever wanted to:
- Work on an open-source game
- Contribute to a LARP project
- Learn multiplayer game development
- Be part of a community building something cool

...this is your chance.

Join us.

---

## Links

- **GitHub:** [github.com/starwards/starwards](https://github.com/starwards/starwards)
- **Discord:** [Join our Discord](https://discord.gg/helios-games) (link placeholder—update with real link)
- **YouTube:** [Helios Games Channel](https://www.youtube.com/@heliosgames)
- **This blog:** [starwards.github.io](https://starwards.github.io)

---

## Thank You

To everyone who's followed Starwards since the beginning: **thank you**.

For reading the blog posts. For starring the repository. For asking questions. For believing in the vision even when we went silent.

We're back. And we're building the simulator we always wanted.

Join us.

*— Amir, Daniel, and the Starwards team*

---

**Previous posts in this series:**
1. [We're Back! (And We Have Stories to Tell)](#)
2. [Letting Go of 3D: A Focus Decision](#)
3. [Engineering Complete: Energy, Heat, and System Effectiveness](#)
4. [Missiles, Torpedoes, and Big Explosions](#)
5. [Armor Reborn: From Design to Reality](#)
6. [Bots, Autopilots, and AI Commanders](#)
7. [Getting Around: Warp, Waypoints, and Docking](#)
8. [Targeting, Fire Control, and Combat Refinements](#)
9. [The Developer Experience Revolution](#)
10. [The Rewrite: Why We Started Fresh](#)
11. **State of Starwards 2025: What's Next** *(you are here)*
