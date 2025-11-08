# Starwards Blog Catch-Up Plan

*Planning document for blog post series covering changes from June 2022 to November 2025*

---

## Context

**Last blog post:** June 19, 2022 - "Radar Damage"

**Gap:** 2.5+ years of development with zero blog posts

**Current date:** November 2025

**Major event:** Complete rewrite/fresh start appears to have begun March 4, 2024

---

## Changes Since Last Blog Post (June 2022)

### Major Architectural Changes

#### Removed: 3D Rendering (PR #1659, March 2024)
- **Deleted:** All `modules/browser/src/3d/` files (lights, meshes, objects, particles, skybox, space-scene)
- **Deleted:** `main-screen.ts` (3D main view)
- **Rationale:** Focus effort on core 2D gameplay and systems (blog discussed 3D as experimental)
- **Impact:** Full pivot to 2D-only PixiJS rendering, aligned with productivity goals

#### Added: Bot AI System (PR #1640, March 2024)
- **New:** `automation-manager.ts` - AI control for NPC ships
- **Orders:** NONE, MOVE (navigate to position), ATTACK (pursue & fire), FOLLOW (formation)
- **Idle Strategies:** PLAY_DEAD, ROAM, STAND_GROUND
- **GM Control:** Right-click commands for ship positioning and combat (blog only mentioned basic "go to" prototype)

#### Added: Waypoint System (PR #1753, May 2024)
- **New:** `waypoint.ts` - Navigation markers in space
- **Features:** Named waypoints, position markers, tactical planning
- **Integration:** GM tools for creating/managing navigation points

### Ship Systems (Not in Blog)

#### Energy & Power Management
- **`reactor.ts`** - Primary energy generation system
  - Properties: `energy`, `efficiencyFactor`
  - Dynamic power distribution across all ship systems
  - Formula: `totalPower = reactor.output × reactor.effectiveness`

- **`energy-manager.ts`** - Power allocation logic
  - Handles power scaling when demand exceeds supply
  - Distributes energy proportionally to system `power` settings
  - Real-time energy balance calculations

#### Heat Management System
- **`heat-manager.ts`** - Thermal regulation
  - Heat accumulation: `heat += usageHeat * dt`
  - Heat dissipation: `heat -= (coolantFactor × coolantPerFactor) * dt`
  - Overheat damage: `heat > 100 → broken = true`
  - Coolant distribution across all systems (blog mentioned as design concept, now implemented)

#### System Effectiveness Formula
- **Implemented:** `effectiveness = broken ? 0 : power × coolantFactor × (1 - hacked)`
- **Applied to:** All ship systems (reactor, thrusters, weapons, radar, etc.)
- **Includes:** Power levels (SHUTDOWN/LOW/MID/HIGH/MAX), coolant allocation, cyber warfare states
- **Blog status:** Was mentioned in design docs but not fully implemented

### Weapons Systems (Major Expansion)

#### Missiles & Torpedo Tubes
- **`tube.ts`** - Missile launcher system (completely new)
  - Properties: `angle`, `loaded`, `loading`, `loadTimeFactor`
  - Array of tubes per ship (configurable count)
  - Loading mechanics with time factors

- **`magazine.ts`** - Ammunition storage (new)
  - Properties: `capacity`, `missiles` (current count)
  - Limited ammo requiring resupply

- **Projectile Types** (expanded from basic chaingun):
  1. **CannonShell** - Basic kinetic projectile
     - Small explosion (radius 100, damage 20)
     - Direct-fire weapon

  2. **BlastCannonShell** - Area denial round
     - Large explosion (radius 200, damage 5, blast 5)
     - Lower damage, higher blast radius

  3. **Missile** - Smart munition (completely new)
     - **Homing capability:** 720°/s rotation, 600 m/s velocity
     - **Proximity detonation:** 100m trigger radius
     - **Massive explosion:** radius 1000, damage 50
     - **60-second flight time**
     - Sophisticated guidance system (blog mentioned torpedoes conceptually)

#### Explosion System
- **`explosion.ts`** - Blast damage mechanics (new)
  - Properties: `secondsToLive`, `expansionSpeed`, `damageFactor`, `blastFactor`
  - Falloff calculation: `damage = baseDamage × (1 - dist/radius)²`
  - Blast force: Applies impulse to nearby objects
  - Different explosion profiles per projectile type

#### Chaingun Enhancements
- **Expanded:** From blog's basic implementation
- **`chain-gun-manager.ts`** - Advanced firing control
  - Rate of fire factor (heat-based modulation)
  - Ammo loading mechanics
  - Fire control integration

### Armor System (Fully Implemented)

**Blog status:** Damage system milestone 2 had basic design, sectional armor concept

**Current implementation:**
- **`armor.ts`** - Complete sectional armor (blog had concept)
  - **Armor plates:** Array of directional plates with individual health
  - **Damage routing:** Hit angle determines which plate takes damage
  - **Breach mechanics:** Plate destruction allows penetration to internal systems
  - **Health tracking:** `healthyPlates` count, `totalHealth` aggregate

- **Fixes:** PRs #1696 (April 2024), #1733 (April 2024)
  - Fixed armor measurement logic
  - Corrected damage calculation formulas
  - Added comprehensive tests

### Navigation & Movement

#### Warp Drive
- **`warp.ts`** - FTL travel system (new)
  - Properties: `chargeLevel`, `currentLevel`, `desiredLevel`
  - Charge/discharge mechanics
  - Integration with ship power systems

#### Smart Pilot (Autopilot)
- **`smart-pilot.ts`** - Advanced automation (blog had basic autopilot concept)
  - Modes: Manual, angle targeting, position targeting
  - `targetAngle`, `targetPosition` properties
  - Integration with bot AI and player commands

#### Maneuvering System
- **`maneuvering.ts`** - Enhanced from blog version
  - Properties: `rotationSpeed`, `afterburnerBoost`
  - Afterburner heat generation (blog mentioned, now fully modeled)
  - Direction-specific thrust capacity

#### Thruster Improvements
- **`thruster.ts`** - Evolved from blog's damage implementation
  - Properties: `angle`, `active`, `efficiency` (new)
  - Per-thruster effectiveness calculations
  - Individual thruster management (blog had basic broken/working states)

### Ship Management Architecture

#### Damage Manager
- **`damage-manager.ts`** - Comprehensive damage routing (blog had basic concept)
  - Armor penetration calculations
  - System damage propagation
  - Malfunction generation (soft/hard problems from blog design)
  - Hit location determination

#### Docking System
- **`docking.ts`** - Ship-to-ship attachment (completely new)
  - Properties: `docked`, `dockedTo`, `dockingRange`
  - `docking-manager.ts` - Attachment logic
  - Enables resupply, repairs, boarding mechanics

#### Movement Manager
- **`movement-manager.ts`** - Unified flight control (expanded)
  - Integrates thrusters, autopilot, manual controls
  - Anti-drift mechanics (blog described drift problem/solution)
  - Breaks, afterburner, strafe controls
  - Velocity mode vs Direct mode (blog implementation)

### Targeting & Combat

#### Targeting System
- **`targeting.ts`** - Fire control (new)
  - Properties: `targetId`, `shipOnly`, `enemyOnly`, `shortRangeOnly`
  - Automatic target filtering
  - Integration with weapons systems

#### Radar Enhancements
- **`radar.ts`** - Enhanced from blog version
  - Properties: `range`, `malfunctionRangeFactor`
  - Malfunction mechanics: Range flicker (blog demonstrated)
  - Radar sharing between ships (blog mentioned as mitigation)

### Pilot Controls (Expanded)

**Blog status:** Basic rotation, boost demonstrated in dogfight

**Current controls:**
- `rotation` [-1,1] - Turn left/right
- `boost` [-1,1] - Forward/reverse thrust
- `strafe` [-1,1] - Lateral movement (new)
- `antiDrift` [0,1] - Velocity opposition (new)
- `breaks` [0,1] - Rapid deceleration (new)
- `afterBurner` [0,1] - Rotation boost with heat (expanded)

**Input system:** Keyboard step-based (0.05 increments) + gamepad axis mapping

### Physics Engine (Enhancements)

#### SpaceManager Improvements
- **Raycast:** Fast projectile hit detection (prevents tunneling)
- **Explosion propagation:** Area damage with inverse-square falloff
- **Collision response:** Impulse-based physics with restitution
- **Spatial hashing:** O(n log n) collision detection via `detect-collisions` library

#### Projectile Physics
- **Homing missiles:** Rotation capacity, velocity capacity, max speed
- **Proximity detonation:** Auto-trigger at range threshold
- **Time-to-live:** Self-destruct for unguided projectiles
- **Raycast intersection:** Ray-sphere math for high-speed projectiles

### Developer Tools & Architecture

#### Decorators (Enhanced)
- **`@gameField`** - Colyseus sync (blog had basic usage)
- **`@tweakable`** - GM/debug UI exposure (new)
- **`@range`** - Value constraints with dynamic bounds (new)
- **`@defectible`** - Malfunction system integration (new)
- **Stacking rules:** Order matters (`@range` → `@tweakable` → `@gameField`)

#### Testing Infrastructure
- **E2E tests:** Playwright integration with snapshot testing
- **Test harnesses:** ShipTestHarness, Multi-Client Driver
- **Test factories:** Standardized ship/scenario creation
- **Blog status:** Minimal tests, now comprehensive coverage

#### GM Tools
- **Tweak UI:** Real-time property manipulation (expanded from blog's basic panel)
- **Object creation:** Drag-and-drop entity spawning
- **Bot commands:** Right-click order issuing
- **Automation manager:** NPC behavior scripting

### Data Structures & State

#### Space Objects
- **Spaceship** - Player/NPC vessels (blog version)
- **Projectile** - Bullets, missiles, shells (expanded)
- **Explosion** - Blast damage volumes (new)
- **Asteroid** - Environmental hazards (blog version)
- **Waypoint** - Navigation markers (new)

#### State Synchronization
- **SpaceRoom:** Shared space simulation (60 Hz updates)
- **ShipRoom:** Per-ship state (one room per ship)
- **AdminRoom:** Game lifecycle management
- **JSON Pointer commands:** Dynamic property paths (enhanced)
- **Delta sync:** Colyseus automatic state diffing

### Integration & External Systems

#### Node-RED Integration
- **Custom nodes:** Starwards-specific flow nodes
- **API exposure:** Ship control, GM commands
- **Event streaming:** Real-time game state to external systems
- **Blog status:** Not mentioned, completely new

#### Scripts API
- **`scripts-api.ts`** - Programmatic game control (new)
- **`automation-manager.ts`** - Bot behavior scripting
- **GM command interface:** External automation support

### Visual & UI

#### Widget System (Expanded from Blog)
**Blog:** Modular drag-and-drop panels demonstrated

**Current widgets:**
- **Armor display** - Sectional damage visualization
- **Ammo counter** - Magazine status
- **Tubes status** - Missile launcher readiness
- **Targeting** - Lock-on interface
- **Warp** - FTL charge/engage
- **Docking** - Ship attachment status
- **Tweak** - GM debug panel
- **Radar** - Tactical/strategic views

#### Screen System
- **Lobby** - Game selection/join
- **Save/Load** - Game state persistence
- **GM Screen** - Map view with interactive controls
- **Ship screens** - Modular station building (blog version)
- **Utilities** - Input configuration, settings

### Maps & Scenarios

#### Map System
- **`maps.ts`** - Scenario definitions (expanded from blog's basic setup)
- **Factory functions:** Programmatic map generation
- **Entity placement:** Ships, asteroids, waypoints
- **Faction setup:** Team configurations

### Technical Debt Addressed

1. **Memory leaks:** Fixed in PR #1680 (March 2024)
   - Proper cleanup of Colyseus subscriptions
   - `.values()` instead of `.toArray()` for MapSchema iteration

2. **Armor damage calculation:** Fixed in PRs #1696, #1733
   - Corrected penetration formulas
   - Fixed plate angle calculation

3. **Test stability:** Multiple fixes (November 2024)
   - Helm-assist test timing
   - Multi-client cleanup timeouts

### Documentation (Since Blog)

**New comprehensive docs:**
- `ARCHITECTURE.md` - System design, data flow
- `SUBSYSTEMS.md` - Ship systems reference
- `PHYSICS.md` - Physics engine details
- `PATTERNS.md` - Code conventions, gotchas
- `TECHNICAL_REFERENCE.md` - Decorators, build tools
- `API_REFERENCE.md` - Commands, events
- `LLM_CONTEXT.md` - AI assistant guide
- `testing/README.md` - Testing guide
- `testing/UTILITIES.md` - Test tools reference
- `INTEGRATION.md` - Node-RED integration

**Blog status:** Minimal documentation, now extensive

### Summary of Major Additions

**Systems not in blog posts:**
1. ✅ Missiles and torpedo tubes
2. ✅ Energy/reactor management
3. ✅ Heat/coolant system
4. ✅ Warp drive
5. ✅ Docking system
6. ✅ Bot AI with orders/strategies
7. ✅ Waypoint navigation
8. ✅ Explosion blast damage
9. ✅ Homing missiles with proximity detonation
10. ✅ Magazine/ammo management
11. ✅ Smart pilot/autopilot
12. ✅ Targeting system
13. ✅ Node-RED integration
14. ✅ Comprehensive armor implementation
15. ✅ System effectiveness formula (full implementation)

**Removed from blog vision:**
1. ❌ 3D rendering (deliberate focus decision)
2. ❌ Corvette class ships (not yet implemented)
3. ❌ Multiple bridges (single-ship focus currently)

**Fully implemented from blog design:**
1. ✅ Sectional armor system
2. ✅ Damage reports and malfunctions
3. ✅ Thruster damage and drift management
4. ✅ Chaingun with airburst (implemented as explosion system)
5. ✅ Dogfight mechanics (complete)
6. ✅ Modular screen building

---

## Blog Post Series Plan

### Overview

**Purpose:** Bring readers up to date with 2.5+ years of development

**Approach:** Thematic organization, not chronological

**Style:** Authentic Starwards voice (transparent, conversational, process-focused)

**Cadence:** One post every 1-2 weeks (series runs 3-5 months)

---

## Post 1: "Letting Go of 3D: A Focus Decision"

**Theme:** Strategic focus and productivity

**Changes covered:**
- Removal of 3D rendering (PR #1659, March 2024)
- Deleted: All 3D infrastructure (lights, meshes, particles, skybox, main-screen)
- Why: Focus effort on core 2D gameplay and systems
- Connection to blog history: The 3D experiments shown in early 2021 posts

**Narrative arc:**
- Reflection on the 3D experiments from 2021
- The realization: 3D was consuming resources without adding LARP value
- Hard decision to remove 6 months of work
- What we gained: Velocity on core systems
- Lesson learned: Sometimes progress means deletion

**Key message:** "We chose depth over spectacle"

**Tags:** `product`, `design`, `technology`

**Tone notes:**
- Honest about the difficulty of deleting work
- Self-reflective about productivity vs. spectacle
- Emphasize LARP value over technical achievement
- Show the decision-making process

**Links to reference:**
- 2021 posts showing 3D experiments
- PR #1659 on GitHub

---

## Post 2: "Engineering Complete: Energy, Heat, and System Effectiveness"

**Theme:** The engineering milestone we promised

**Changes covered:**
- Reactor and energy management system
- Heat and coolant distribution
- System effectiveness formula implementation
- Power allocation when demand exceeds supply
- Coolant factor affecting all systems
- Overheat damage mechanics

**Narrative arc:**
- Callback to Milestone 2 (damage system) from March 2021
- "We promised engineering content - here it is"
- How energy flows through the ship
- The interconnected web: power affects heat affects effectiveness
- Real consequences: brown-outs, overheat shutdowns
- LARP implications: Role differentiation for engineers

**Key message:** "Every system is now a living, breathing part of the ship"

**Technical deep-dive:**
- Formula: `effectiveness = broken ? 0 : power × coolantFactor × (1 - hacked)`
- Energy budget calculations
- Heat accumulation and dissipation math
- Code snippets showing implementation

**Tags:** `product`, `technology`, `game-design`, `stations`

**Tone notes:**
- Educational - explain the formulas
- Show interconnections between systems
- Use parenthetical asides to explain technical terms
- Celebrate the complexity without being overwhelming

**Links to reference:**
- "Moving to the second milestone" (March 2021)
- "Designing a damage system" (April 2021)

---

## Post 3: "Missiles, Torpedoes, and Big Explosions"

**Theme:** Long-range engagement circle implementation

**Changes covered:**
- Missile and torpedo tube system
- Magazine and ammunition management
- Three projectile types (CannonShell, BlastCannonShell, Missile)
- Homing missiles with 720°/s rotation capacity
- Proximity detonation mechanics
- Explosion system with blast damage and force
- Inverse-square falloff physics

**Narrative arc:**
- Callback to "Engagement Circles" post (Feb 2021)
- We had chainguns (close range) - now we have missiles (long range)
- The weapon system we dreamed about
- Smart munitions that think
- Proximity fuses and area denial
- LARP impact: Tactical depth, weapons officer role

**Key message:** "The three engagement circles are now complete"

**Technical showcase:**
- Homing algorithm (rotation capacity, velocity capacity, max speed)
- Proximity detonation trigger at 100m
- Explosion propagation with physics
- Comparison table of all three projectile types

**Visual elements:**
- Missile homing GIF/video
- Explosion effect screenshots
- Proximity detonation demonstration

**Tags:** `product`, `weapons`, `design`, `technology`

**Tone notes:**
- Excitement about smart munitions
- Technical details on homing and proximity
- Comparison to real-world systems (if applicable)
- Show how it completes the engagement circle vision

**Links to reference:**
- "Engagement Circles" (Feb 2021)
- Videos of real CIWS, torpedoes (like original post)

---

## Post 4: "Armor Reborn: From Design to Reality"

**Theme:** Implementing the vision

**Changes covered:**
- Full sectional armor implementation
- Directional armor plates with individual health
- Hit angle calculation and damage routing
- Breach mechanics and penetration
- Armor damage fixes (PRs #1696, #1733)
- Visual armor display widget

**Narrative arc:**
- Callback to "Damage System" design post (April 2021)
- We had the design on paper, inspired by Battletech
- From concept to code: The implementation journey
- The bugs we found and fixed (April 2024 fixes)
- How it plays: Angling your ship matters
- LARP impact: Tactical positioning, damage reports

**Key message:** "The damage system we designed three years ago is now real"

**Visual elements:**
- Show armor plate diagrams
- Damage visualization screenshots
- Before/after of armor fixes
- Armor widget in action

**Technical showcase:**
- Hit angle calculation
- Damage routing algorithm
- Breach probability mechanics

**Tags:** `product`, `damage`, `design`, `technology`

**Tone notes:**
- Satisfaction at completing a long-term vision
- Honesty about bugs and fixes
- Battletech inspiration (as in original post)
- Emphasize tactical implications

**Links to reference:**
- "Designing a damage system" (April 2021)
- PRs #1696, #1733 on GitHub
- Original Battletech armor diagram

---

## Post 5: "Bots, Autopilots, and AI Commanders"

**Theme:** Automation and autonomy

**Changes covered:**
- Bot AI system with orders (MOVE, ATTACK, FOLLOW)
- Idle strategies (PLAY_DEAD, ROAM, STAND_GROUND)
- GM command interface (right-click orders)
- Smart pilot/autopilot system
- Automation manager for scripting
- Integration with movement controls

**Narrative arc:**
- Remember "Working on simple AI commands" (June 2022)?
- From spiral-bug to full AI framework
- Orders system: What GMs wanted
- Idle behaviors: Ships that feel alive
- Autopilot: Helping players focus on tactics
- LARP impact: GMs can run complex scenarios, players get assistance

**Key message:** "Ships can think for themselves now"

**Demonstration:**
- Attack order flowchart
- Formation flying with FOLLOW
- STAND_GROUND ambush tactics
- Autopilot modes comparison

**Tags:** `product`, `gm`, `AI`, `technology`, `game-design`

**Tone notes:**
- Callback to the spiral bug with humor
- Show how complexity grew from simple prototype
- Emphasize GM empowerment
- Discuss AI "personality" through idle behaviors

**Links to reference:**
- "Working on simple AI commands" (June 2022)
- PR #1640 on GitHub

---

## Post 6: "Getting Around: Warp, Waypoints, and Docking"

**Theme:** Navigation and ship operations

**Changes covered:**
- Warp drive system (FTL travel)
- Waypoint navigation markers
- Docking system (ship-to-ship)
- Enhanced movement controls (strafe, antiDrift, breaks)
- Movement manager unification
- Afterburner heat generation

**Narrative arc:**
- From dogfights to strategic movement
- Warp drive: Finally leaving the neighborhood
- Waypoints: Tactical planning and coordination
- Docking: Resupply, repairs, boarding
- The full pilot's toolkit
- LARP impact: Larger maps, complex missions

**Key message:** "The universe just got bigger"

**Feature showcase:**
- Warp charge/engage sequence
- Waypoint-based mission planning
- Docking maneuvers and protocols
- Enhanced control scheme explanation

**Visual elements:**
- Warp effect screenshots
- Waypoint markers on tactical display
- Docking sequence

**Tags:** `product`, `technology`, `stations`, `game-design`

**Tone notes:**
- Excitement about scale expansion
- Technical details on warp mechanics
- Practical examples of waypoint use
- Docking as gameplay moment, not just feature

**Links to reference:**
- PR #1753 (waypoints)
- Early posts about map scale

---

## Post 7: "Targeting, Fire Control, and Combat Refinements"

**Theme:** Polishing the combat experience

**Changes covered:**
- Targeting system with filters
- Radar enhancements and malfunction mechanics
- Enhanced chaingun with rate-of-fire modulation
- Physics improvements (raycast, spatial hashing)
- Collision response and impulse
- Combat widget improvements

**Narrative arc:**
- Building on the dogfight foundation
- From basic lock-on to sophisticated fire control
- Target filters: shipOnly, enemyOnly, shortRangeOnly
- Radar damage that matters
- Physics that feel right
- LARP impact: Deeper tactical play

**Key message:** "Combat that rewards skill and coordination"

**Technical showcase:**
- Target filtering logic
- Raycast vs. continuous collision detection
- Spatial hashing benefits
- Radar malfunction implementation

**Tags:** `product`, `weapons`, `technology`, `dogfight`

**Tone notes:**
- Polish as iterative improvement
- Physics "feel" is subjective but important
- Radar callback to last blog post
- Integration of many small improvements

**Links to reference:**
- "Radar Damage" (June 2022) - the last post!
- Original dogfight milestone posts

---

## Post 8: "The Developer Experience Revolution"

**Theme:** Making Starwards welcoming to contributors

**Changes covered:**
- Comprehensive documentation (10+ new docs)
- Testing infrastructure (Playwright E2E, test harnesses)
- Enhanced decorators (@tweakable, @range, @defectible)
- GM tools and tweak UI
- Node-RED integration
- Code patterns and conventions

**Narrative arc:**
- Remember "Starwards is now open-source" (June 2022)?
- We said it showed "signs of being a closed project"
- The documentation effort
- Testing: From minimal to comprehensive
- Tools that make development joyful
- Node-RED: External integration possibilities
- LARP impact: Easier for organizers to customize

**Key message:** "We're building a platform, not just a game"

**Developer showcase:**
- Documentation structure overview
- Test harness demo
- Decorator examples
- Node-RED flow example

**Tags:** `technology`, `product`

**Tone notes:**
- Honest about original shortcomings
- Pride in improvement
- Educational focus on the tools
- Invitation to contribute

**Links to reference:**
- "Starwards is now open-source" (June 2022)
- GitHub repository
- Documentation files

---

## Post 9: "The Rewrite: Why We Started Fresh"

**Theme:** Technical maturity and architecture evolution

**Changes covered:**
- The decision to rewrite (March 2024 start date)
- Colyseus architecture refinement
- State synchronization improvements
- SpaceRoom + ShipRoom architecture
- JSON Pointer commands
- Performance optimizations (memory leak fixes)

**Narrative arc:**
- Looking at the 2021-2022 codebase
- What we learned from the prototype
- The decision to start fresh
- Carrying forward the good parts
- Lessons from EmptyEpsilon fork experience
- LARP impact: More stable, more scalable

**Key message:** "Sometimes you need to rebuild the foundation"

**Technical reflection:**
- Architecture diagrams (old vs new)
- What stayed, what changed, what improved
- Performance metrics
- Memory leak example and fix

**Tags:** `technology`, `product`, `story`

**Tone notes:**
- Deep reflection on technical decisions
- Honest about prototype limitations
- EmptyEpsilon experience as teacher
- Maturity in accepting the need to rewrite

**Links to reference:**
- "The Epsilon Saga" (Jan 2021) - parallel journey
- PR #1680 (memory leak fix)

---

## Post 10: "State of Starwards 2025: What's Next"

**Theme:** Looking forward

**Changes covered:**
- Summary of everything achieved
- Current state of the project
- What's still missing from original vision:
  - Corvette class ships
  - Multiple bridges
  - Advanced damage reports
  - Cyber warfare gameplay
- Community growth
- Roadmap for next year

**Narrative arc:**
- Where we've been (blog summary)
- Where we are (current capabilities)
- Where we're going (roadmap)
- Call to action: Join us
- LARP impact: Production readiness assessment

**Key message:** "Join us in building the simulator we always wanted"

**Community focus:**
- Contribution opportunities
- How to get started
- Discord invite
- Upcoming features vote

**Tags:** `product`, `story`

**Tone notes:**
- Celebration of progress
- Honesty about remaining work
- Invitation and welcome
- Vision for future

**Links to reference:**
- All previous posts in series
- Original vision posts from 2021
- GitHub repository
- Discord server

---

## Publishing Strategy

### Order Rationale

1. **Post 1 (3D removal)** - Opens with bold strategic decision, shows maturity
2. **Post 2 (Engineering)** - Delivers on old promise, rewards long-time readers
3. **Post 3 (Missiles)** - Exciting feature, completes engagement circles vision
4. **Post 4 (Armor)** - Another promise delivered, technical depth
5. **Post 5 (AI/Bots)** - Continues from last 2022 post, shows evolution
6. **Post 6 (Navigation)** - Expands scope, shows ambition
7. **Post 7 (Combat polish)** - Brings combat story together
8. **Post 8 (Developer Experience)** - Addresses 2022 open-source concerns
9. **Post 9 (Rewrite)** - Technical retrospective, shows learning
10. **Post 10 (Future)** - Inspires participation, calls to action

### Cadence

**One post every 1-2 weeks**
- Series runs 3-5 months total
- Allows time for visuals, editing, community response
- Maintains momentum without overwhelming readers

### Cross-References

- Each post links back to relevant 2021-2022 blog posts
- Each post links to GitHub PRs where applicable
- Final post links to all previous posts in series
- Creates a web of narrative connections

### Visuals Needed

**For each post:**
- Screenshots of new features
- Diagrams (energy flow, armor system, AI orders)
- GIFs/videos (missile homing, explosions, docking)
- Code snippets (system effectiveness formula, homing algorithm)

**General:**
- Update main screen images
- Radar screenshots showing enhancements
- Widget screenshots
- Architecture diagrams

### Tone Guidelines

**DO:**
- Use "we" as default voice
- Start with context/background
- Explain technical decisions with rationale
- Show the journey, not just the destination
- Include multimedia to illustrate points
- Link to related posts and external resources
- Use headers liberally for structure
- Admit mistakes and learning moments
- Ask rhetorical questions to engage readers
- Use parentheses for clarifications
- End with clear conclusions or next steps

**DON'T:**
- Use marketing/hype language
- Skip over failures or challenges
- Assume readers know all terminology
- Make posts pure announcements without context
- Use excessive bold or ALL CAPS
- Write in first-person singular (unless specifically attributed)
- Present decisions without explaining the "why"
- Make posts too short (prefer depth over brevity)

**Tone Checklist:**
- [ ] Conversational but informative
- [ ] Honest about challenges
- [ ] Transparent about decision-making
- [ ] Accessible to non-experts
- [ ] Shows personality/humor
- [ ] Respects reader intelligence

---

## Post-to-Changes Mapping

### Post 1: 3D Removal
- PR #1659
- Deleted: `modules/browser/src/3d/` entire directory
- Deleted: `main-screen.ts`

### Post 2: Engineering
- `reactor.ts`
- `energy-manager.ts`
- `heat-manager.ts`
- `system.ts` (effectiveness formula)
- Coolant distribution logic

### Post 3: Missiles
- `tube.ts`
- `magazine.ts`
- `projectile.ts` (3 types: CannonShell, BlastCannonShell, Missile)
- `explosion.ts`
- Homing mechanics (rotation capacity, velocity capacity)
- Proximity detonation (100m trigger)

### Post 4: Armor
- `armor.ts`
- `damage-manager.ts`
- PRs #1696, #1733
- Sectional plates implementation
- Penetration mechanics
- Armor widget

### Post 5: AI/Bots
- `automation-manager.ts`
- `smart-pilot.ts`
- Bot orders: MOVE, ATTACK, FOLLOW
- Idle strategies: PLAY_DEAD, ROAM, STAND_GROUND
- PR #1640
- GM command interface

### Post 6: Navigation
- `warp.ts`
- `waypoint.ts` (PR #1753)
- `docking.ts` + `docking-manager.ts`
- `movement-manager.ts`
- Enhanced pilot controls (strafe, antiDrift, breaks)

### Post 7: Combat Polish
- `targeting.ts`
- `radar.ts` enhancements
- `chain-gun-manager.ts`
- Physics improvements (raycast, spatial hashing)
- Collision response

### Post 8: Developer Experience
- All documentation files
- Testing infrastructure (Playwright, test harnesses)
- Decorators (`@tweakable`, `@range`, `@defectible`)
- GM tools and tweak UI
- Node-RED integration

### Post 9: Rewrite
- Architecture decisions (March 2024 rewrite start)
- Colyseus patterns (SpaceRoom, ShipRoom, AdminRoom)
- State synchronization improvements
- Memory leak fixes (PR #1680)
- JSON Pointer commands

### Post 10: Future Vision
- Roadmap items
- Missing features from original vision
- Community call to action
- Production readiness assessment

---

## Key Narrative Threads

### Thread 1: Promises Kept
- Engineering system (promised in Milestone 2)
- Sectional armor (designed in 2021, implemented 2024)
- Engagement circles (completed with missiles)
- Damage system (fully realized)

### Thread 2: Hard Decisions
- Removing 3D rendering
- Starting fresh (rewrite)
- Focus on depth over breadth
- LARP value over technical achievement

### Thread 3: Evolution
- From spiral-bug to sophisticated AI
- From basic chaingun to complete weapons suite
- From prototype to production-ready
- From closed to open, from undocumented to comprehensive

### Thread 4: Community
- Open-source commitment
- Documentation effort
- Developer experience improvements
- Call to contribute

### Thread 5: Technical Maturity
- From prototype to architecture
- From bugs to tests
- From hacks to patterns
- From EmptyEpsilon lessons to Starwards foundation

---

## Connections to Blog History

### 2021 Posts to Reference

- **"Welcome" (Jan 2021)** - The beginning
- **"The Epsilon Saga" (Jan 2021)** - Lessons from forking
- **"The first game design milestone" (Feb 2021)** - Dogfight focus
- **"The space fighter dilemma" (Feb 2021)** - Fighter justification
- **"Engagement Circles" (Feb 2021)** - Weapon range design
- **"Dogfight Showcase" (Mar 2021)** - The milestone delivered
- **"Moving to the second milestone" (Mar 2021)** - Engineering focus
- **"Designing a damage system" (Apr 2021)** - Armor concept
- **Various peek posts** - Visual progress

### 2022 Posts to Reference

- **"Starwards is now open-source" (Jun 2022)** - Community commitment
- **"Working on simple AI commands" (Jun 2022)** - AI beginning
- **"Radar Damage" (Jun 2022)** - The last post

---

## Success Metrics

### For Each Post

- [ ] Explains "why" behind decisions
- [ ] Shows journey, not just destination
- [ ] Links to relevant past posts
- [ ] Includes technical depth
- [ ] Accessible to non-experts
- [ ] Includes visuals/multimedia
- [ ] Ends with implications/next steps
- [ ] Maintains Starwards voice

### For Series Overall

- [ ] Covers all major changes since 2022
- [ ] Tells coherent narrative arc
- [ ] Honors blog history and promises
- [ ] Invites community participation
- [ ] Educates readers on systems
- [ ] Demonstrates technical maturity
- [ ] Positions project for future
- [ ] Re-engages dormant audience

---

## Notes for Future Writing Sessions

### Voice Consistency

**Key phrases from blog history:**
- "Easy peasy!"
- "Fork it"
- "Dead simple, right?"
- "After giving it a deep thought..."
- "As we strive to..."
- "We like..." (expressing preferences)
- "So here we are..."

### Structural Patterns

**Decision posts:**
1. Present dilemma
2. List evaluation criteria
3. Analyze each option
4. State decision clearly
5. Justify with reference to values
6. Acknowledge trade-offs

**Technical posts:**
1. High-level concept
2. Why it matters
3. Technical details
4. Examples/analogies
5. Visual demonstration
6. Connection to game experience

**Reflection posts:**
1. Look back at past state
2. Describe journey/struggle
3. Show learning moments
4. Articulate current state
5. Extract lessons
6. Point to future

### Integration Points

**Each post should:**
- Reference at least 1-2 past blog posts
- Link to GitHub PRs/issues where relevant
- Include LARP impact section
- Show technical depth with code/formulas
- Use multimedia to support narrative
- End with implications or next steps

### Common Pitfalls to Avoid

- ❌ Pure feature announcements
- ❌ Marketing language
- ❌ Hiding challenges/failures
- ❌ Assuming technical knowledge
- ❌ Skipping justification
- ❌ Forgetting LARP context
- ❌ Being too brief (depth is valued)

---

## Future Session Workflow

**When writing a post:**

1. **Review this document** - Understand the post's role in series
2. **Read WRITING_STYLE_ANALYSIS.md** - Internalize voice
3. **Review referenced past posts** - Understand callbacks
4. **Identify technical details** - Find code/PRs to reference
5. **Draft structure** - Use appropriate pattern (decision/technical/reflection)
6. **Write content** - Maintain voice, depth, honesty
7. **Add multimedia notes** - Mark where screenshots/videos needed
8. **Cross-reference** - Link to past posts and future context
9. **Review checklist** - Ensure success metrics met
10. **Prepare for publishing** - YAML front matter, tags, filename

---

*This document serves as the comprehensive planning context for the Starwards blog catch-up series. Use it to maintain consistency, honor the blog's history, and tell a compelling narrative of the project's evolution from June 2022 to November 2025.*
