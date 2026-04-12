---
layout: post
title: We're Back
subtitle: Four years of Starwards development, condensed
tags: [product, story, technology]
---

The last blog post was in June 2022. It's been almost four years. A lot happened - both in the project and in our lives - and we owe you an update.

We're not going to be dramatic about the silence. Life got complicated (a war started in October 2023, and Amir eventually immigrated to the Netherlands in late 2025), and somewhere along the way writing blog posts fell off the priority list. The project never stopped, though. It slowed down, sped up, and changed shape - but it kept going.

Here's what actually happened.

## 2022 Was Good to Us

The second half of 2022 was, by a wide margin, the most productive period in the project's history. We made a gap analysis for a LARP-playable version, and that gave us more realistic goals to pursue. We formalized them into a list of tasks and milestones - in other words, a Plan. We shipped 15 releases between August and December. This is when most of the core systems were built:

- **Station screens** - proper hard-coded screen per station (Pilot, Weapons)
- **Warp drives** - FTL travel with charging mechanics and heat management
- **Docking** - ship-to-ship attachment for resupply
- **Waypoints and pilot radar** - navigation beyond "fly towards the dot"
- **Node-RED integration** - bridging the game to the IoT ecosystem
- **Magazine and ammo systems** - finite ammunition with loading mechanics
- **System status widgets** - status readouts for ship systems

We also migrated to PixiJS 7 and established a release pipeline. By the end of 2022, the game had gone from "dogfight prototype" to something that looked like an actual bridge simulator with multiple stations.

## 2023 Was More Challenging

2023 was a different story. In the first half, we followed the plan to build the Engineering Control Room screen - power allocation, coolant management, warp controls, the armor widget. It was good work that rounded out the engineering gameplay we'd been designing since the [second milestone]({% post_url 2021-03-27-2nd-milestone %}).

We had planned a LARP event for December 2023 - one last run using EmptyEpsilon before switching fully to Starwards. That game became our focus and we put Starwards aside in favor of smaller systems that were actually relevant to its success. But then the war started in October, and those plans went up in smoke along with a lot of other things.

One thing that did start in early 2023 was using AI-assisted development. At first it was modest - help with boilerplate, exploring design options, that sort of thing. This turned out to be more important than we realized at the time.

## 2024: The Refocus

By early 2024, the project felt like it was over. The codebase had grown in so many directions - 3D rendering, engineering systems, weapons, navigation - but it wasn't playable as a LARP product, and it didn't seem like it was going to happen any time soon. Plan or not, it still lacked focus.

The biggest call was removing the 3D main screen: a friend who was learning Unity offered to make a contribution to the project. We'd had a Babylonjs-based 3D view running alongside the PixiJS 2D tactical display [since 2021]({% post_url 2021-01-29-first-3d %}) and we were already invested in making it work and look nice, but it was going nowhere, and the chance of having all the 3D stuff handled in a native client with a powerful engine to render it (not to mention a dedicated developer/designer) was tempting. We had a modest proof-of-concept showing that a Unity client could connect via Colyseus's polyglot support. Also worth remembering that for LARP technical play the 3D view is eye candy and a centerpiece, but the 2D view is genuinely better - you can see all ships at once, distances are clear, no occlusion issues. So we decided to focus on 2D now, do 3D properly as a separate Unity client later, and deleted 4,523 lines of 3D code in March 2024.

The rest of 2024 was cleanup and refinement:

- **Memory leak fixes** - Colyseus schema listeners accumulating, MapSchema `.toArray()` issues. The kind of bugs you only find after long sessions.
- **Armor system fixes** - The [sectional armor]({% post_url 2021-04-03-damage-system %}) we designed in 2021 was finally fixed. Hit angle calculations and damage formulas worked.
- **Bot AI and GM controls** - Remember the [spiral bug]({% post_url 2022-06-12-simple-ai-commands-wip %})? We used AI to simplify and debug all the extrapolation formulas used by the smart pilot. Fight fire with fire! The smart pilot got a proper rewrite with angle targeting, position targeting, and tactical orders (MOVE, ATTACK, FOLLOW). GMs can now right-click to command NPC ships.
- **Object lifecycle** - GMs can create and destroy objects. Sounds basic, but it wasn't there before.

2024 was not such a big year in terms of features, but it was a critical step towards completion. Focusing on the core value proposition and solidifying it. And the war continued.

## 2025: The Revival

Most of 2025 was quiet in terms of this project. Serious adult stuff needed our full attention, which eventually ended up with Amir and his family immigrating in October '25 to a place with less war and suffering. And then in Q4 things picked up again - 131 commits between October and December, but the focus was different from previous bursts.

This time it was about sustainability: making the project something that could survive our increasingly busy lives. We integrated LLMs into the development workflow: made it write extensive documentation (architecture guides, subsystem specs, physics docs, development patterns), and build out Playwright E2E testing.

That LLM part deserves a mention. AI-assisted development is what makes this project viable for us right now. We both have day jobs and lives that are more complicated than they were in 2021 (and 2021 was complicated plenty). We are invested in the chance that the ability to describe what we want, review what gets produced, and iterate quickly will change the economics of side-project development.

## 2026 Is Where We're At

2026 so far has been about pushing forward, slowly implementing the same plan we made in 2022, while improving LLM effectiveness. We finished up some weapons issues and started working on the long range signals radar. An internal preview deployment for each PR will allow us to move more features concurrently and spend time only on making decisions and reviewing the work. Daniel is coming back to active development soon, also working in this style.

## Where This Leaves Us

So that's the story. Four years of uneven progress, shaped by both technical decisions and life circumstances. The game is significantly more complete than when the blog went silent - the core systems we designed in 2021 are now implemented and working.

The next post covers where Starwards actually stands today: what's built, what works, and what's still missing.
