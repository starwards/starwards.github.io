---
layout: post
title: We're Back
subtitle: Four years of Starwards development, condensed
tags: [product, story, technology]
---

The last blog post was in June 2022. It's been almost four years. A lot happened — both in the project and in our lives — and we owe you an update.

We're not going to be dramatic about the silence. Life got complicated (a war started in October 2023, and Amir eventually immigrated to the Netherlands in late 2025), and somewhere along the way writing blog posts fell off the priority list. The project never stopped, though. It slowed down, sped up, and changed shape — but it kept going.

Here's what actually happened.

## The 2022 Golden Era

The second half of 2022 was, by a wide margin, the most productive period in the project's history. We pushed over 500 commits and shipped 15 releases (v0.0.4 through v0.5.1) between August and December. If you look at the git log from that period, it's almost hard to believe.

This is when most of the core systems were built:

- **Warp drives** — FTL travel with charging mechanics and heat management
- **Docking** — ship-to-ship attachment for resupply
- **Waypoints and pilot radar** — navigation beyond "fly towards the dot"
- **Weapons station screen** — a proper gunner interface
- **Pilot station screen** — helm controls that made sense
- **Node-RED integration** — external scripting for GMs and scenario designers
- **Magazine and ammo systems** — finite ammunition with loading mechanics
- **System status widgets** — engineering readouts for ship systems

We also migrated to PixiJS 7 and established a release pipeline. By the end of 2022, the game had gone from "dogfight prototype" (which is where the blog left off) to something that looked like an actual bridge simulator with multiple stations.

## 2023: Slowing Down

2023 was a different story. Only 35 commits the entire year. In the first half, we built the Engineering Control Room screen — power allocation, coolant management, warp controls, the armor widget. It was good work that rounded out the engineering gameplay we'd been designing since the [second milestone]({% post_url 2021-03-27-2nd-milestone %}).

We had planned a LARP event for December 2023 — one last run using EmptyEpsilon before switching fully to Starwards. Then the war started in October, and those plans fell apart along with a lot of other things.

One thing that did start in early 2023 was using AI-assisted development. At first it was modest — help with boilerplate, exploring design options, that sort of thing. This turned out to be more important than we realized at the time.

## 2024: The Refocus

By early 2024, we had a decision to make. The codebase had grown in many directions — 3D rendering, engineering systems, weapons, navigation — but it wasn't playable as a LARP product. We needed to focus.

The biggest call was removing the 3D main screen. We'd had a Three.js-based 3D view running alongside the PixiJS 2D tactical display since 2021 (we even [blogged about it]({% post_url 2021-01-29-first-3d %})). Maintaining two rendering systems was expensive, and for LARP play the 2D tactical view is genuinely better — you can see all ships at once, distances are clear, no occlusion issues. We had a modest proof-of-concept showing that a Unity client could connect via Colyseus's polyglot support, so the plan became: focus on 2D now, do 3D properly as a separate Unity client later. That PR deleted 4,523 lines of 3D code in March 2024.

The rest of 2024 was cleanup and refinement:

- **Memory leak fixes** — Colyseus schema listeners accumulating, MapSchema `.toArray()` issues. The kind of bugs you only find after long sessions.
- **Armor system fixes** — The [sectional armor]({% post_url 2021-04-03-damage-system %}) we designed in 2021 was finally implemented correctly. Hit angle calculations and damage formulas that actually worked.
- **Bot AI and GM controls** — Remember the [spiral bug]({% post_url 2022-06-12-simple-ai-commands-wip %})? The smart pilot got a proper rewrite with angle targeting, position targeting, and tactical orders (MOVE, ATTACK, FOLLOW). GMs can now right-click to command NPC ships.
- **Object lifecycle** — GMs can create and destroy objects. Sounds basic, but it wasn't there before.

106 commits total. Not a huge number, but targeted work that made the game significantly more solid.

## 2025: The Revival

Most of 2025 was quiet. Then in Q4, things picked up again — 131 commits between October and December, but the focus was different from previous bursts.

This time it was about sustainability: making the project something that could survive our increasingly busy lives. We wrote extensive documentation (architecture guides, subsystem specs, physics docs, development patterns), built out Playwright E2E testing, set up CI/CD with preview deployments, and integrated Claude Code into the development workflow.

That last part deserves a mention. AI-assisted development is what makes this project viable for us right now. We both have day jobs and lives that are more complicated than they were in 2021. The ability to describe what we want, review what gets produced, and iterate quickly has changed the economics of side-project development. Daniel is coming back to active development soon, also working in this style.

## Where This Leaves Us

So that's the story. Four years of uneven but persistent progress, shaped by both technical decisions and life circumstances. The game is significantly more complete than when the blog went silent — all the core systems we designed in 2021 are now implemented and working.

The next post covers where Starwards actually stands today: what's built, what works, and what's still missing.
