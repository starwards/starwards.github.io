---
layout: post
title: "Letting Go of 3D: A Focus Decision"
subtitle: Sometimes progress means deleting six months of work
tags: [product, design, technology]
---

In March 2024, we opened [Pull Request #1659](https://github.com/starwards/starwards/pull/1659). The title was straightforward: "Remove 3D rendering."

The diff was brutal: **4,523 deletions**. No additions. Just deletions.

We removed:
- The entire `modules/browser/src/3d/` directory
- Lights, meshes, objects, particles, skybox, space-scene—all of it
- The 3D main screen view we'd built
- Six months of work from 2021

And then we merged it.

If you've been following Starwards since the early days, you might remember the 3D experiments. We were excited about them. We showed them off in blog posts and videos. They looked cool. Spinning 3D ship models, particle effects, a proper space skybox—all the stuff you'd expect from a space game.

So why did we delete it all?

The short answer: focus. The longer answer involves some hard lessons about productivity, scope, and knowing what actually matters for the experience we're trying to create.

## The 3D Dream

Let's go back to 2021. We'd just finished the dogfight milestone. Starwards was working—ships could fly, shoot, take damage. But it was all 2D. Top-down tactical view using PixiJS for rendering.

And we started thinking: wouldn't it look amazing in 3D?

Imagine: a first-person view from the bridge. 3D ship models with proper lighting. Particle effects for engine trails and explosions. A realistic space environment with skyboxes and nebulae.

It was seductive. Space games are *supposed* to be 3D, right? Elite Dangerous, Star Citizen, Everspace—they're all 3D. And we had the technical chops to do it. How hard could it be?

(Narrator: It was hard.)

## The Reality of 3D

Here's what we learned very quickly: 3D rendering is a deep, deep rabbit hole.

You can't just slap Three.js onto your PixiJS game and call it a day. You need:
- 3D models for every ship (modeled, textured, optimized)
- A lighting system that looks good
- Particle systems for effects
- Camera management (multiple views, smooth transitions)
- Performance optimization (3D is expensive)
- Integration with your existing 2D UI

And every one of those items expands into sub-items. Want good lighting? You're learning about ambient vs. directional vs. point lights, shadows, normal maps. Want particle effects? You're diving into sprite sheets, billboard rendering, alpha blending.

We spent months on it. And we got it working! The 3D view existed. It was functional. You could see ships in 3D, flying through space with a skybox behind them.

But here's the thing we slowly realized: **it didn't add LARP value**.

## The LARP Value Question

Starwards isn't a single-player space sim. It's a multiplayer LARP simulator. The goal isn't to make *you* feel like a spaceship pilot—it's to make a *room full of people* feel like they're running a spaceship together.

That changes everything.

In a LARP bridge simulator, players aren't staring at a first-person view. They're at stations. The pilot has their controls. The weapons officer has their targeting display. The engineer has their power management screen. The captain has the tactical overview.

And almost universally, what they need is *information*, not immersion.

The pilot needs to know: Where am I? Where am I going? What's my velocity? Where are the enemies?

The weapons officer needs to know: What's in range? What's targeted? When can I fire?

The engineer needs to know: Which systems are damaged? How's my power budget? Where's the heat building up?

A 3D view answers... almost none of those questions effectively.

You can show a ship in 3D, spinning beautifully in space. But can you tell at a glance which armor plates are damaged? Not really. Can you see the tactical situation of five ships in a furball? Not as well as a top-down view. Can you read your exact heading and velocity? Only if you overlay a bunch of UI, at which point why have 3D at all?

The 2D tactical view we already had was *better* at conveying the information players needed. It was clearer. It was faster to read. It scaled better to multiple ships.

We'd spent six months building something that looked cool but made the game harder to play.

## The Productivity Cost

But the LARP value question wasn't the only issue. There was also the opportunity cost.

Every hour we spent tweaking the 3D lighting was an hour we *didn't* spend implementing:
- The energy management system we'd designed
- Missiles and torpedoes
- The sectional armor system
- Heat and coolant distribution
- Docking mechanics
- Warp drives

All the engineering content we'd been promising since the "second milestone" post in March 2021. All the systems that would actually deepen the LARP experience.

We were polishing the spectacle while neglecting the substance.

And here's the uncomfortable truth: 3D rendering is *fun* to work on. It's visually rewarding. You make a change, refresh the page, and boom—prettier explosions. Instant gratification.

Energy management? That's math and game balance and UI work. It's harder. It's less immediately satisfying. But it's what makes the game actually interesting to play.

We were procrastinating on hard work by doing fun work. And the fun work was consuming resources we didn't have.

## The Decision

After giving it deep thought (and after starting the rewrite in March 2024), we asked ourselves: What if we just... removed it?

What if we fully committed to 2D? Not as a limitation, but as a *strength*. Not "we can't do 3D," but "we're choosing clarity over spectacle."

The tactical view could be our signature. Bridge simulators like Artemis and EmptyEpsilon use 2D tactical displays—and they work. They're clear, they're functional, they communicate information effectively.

We could take the time we'd spend maintaining 3D rendering and pour it into:
- Better tactical displays
- More informative widgets
- Clearer damage visualization
- Richer system interactions

We could choose *depth* over *spectacle*.

And so we did. PR #1659. Delete it all. Start fresh.

## What We Kept

To be clear: we didn't delete everything visual. We kept (and improved) all the 2D rendering:
- PixiJS for all graphics
- The tactical overhead view
- Ship sprites and effects
- The modular widget system
- The radar displays

We just stopped trying to render a 3D scene alongside it. We simplified. We focused.

## What We Gained

Since making this decision, here's what we've shipped:
- Complete energy, heat, and coolant systems (Post 2 in this series)
- Missiles with homing and proximity detonation (Post 3)
- Full sectional armor implementation (Post 4)
- Sophisticated bot AI (Post 5)
- Warp drives, waypoints, docking (Post 6)
- Combat refinements and targeting systems (Post 7)
- Comprehensive documentation and testing (Post 8)

Would we have shipped all that if we'd kept the 3D rendering? Honestly? Probably not. We'd still be tweaking light positions and optimizing shadow rendering.

The 3D work was a tax on every other feature. Removing it felt like taking off ankle weights we didn't know we were wearing.

## The Lesson

Here's what we learned: **Scope is the enemy of depth.**

You can build a game with a hundred features, each one shallow. Or you can build a game with twenty features, each one deep and polished and interconnected.

For a LARP simulator, depth wins every time. We'd rather have a rich energy management system that creates interesting engineering decisions than a pretty 3D skybox.

We'd rather have armor that works exactly right—with angle calculations and penetration mechanics and visual feedback—than have 3D ship models spinning in space.

We'd rather players spend their time managing heat distribution and power allocation than admiring particle effects.

None of this means 3D is bad. It means 3D wasn't right *for us*, *for this project*, *at this stage*.

Maybe someday we'll revisit it. Maybe when all the core systems are done, we'll look at adding a 3D tactical view as an alternative. Maybe.

But for now, we're 2D and proud.

## The Pull Request

If you want to see exactly what we deleted, [PR #1659](https://github.com/starwards/starwards/pull/1659) is still up on GitHub. It's oddly satisfying to scroll through thousands of red deletion lines.

It represents a decision. A focus. A commitment to building the game we actually want to play, not the game we think we're supposed to build.

Sometimes progress looks like addition. Sometimes it looks like deletion.

This time, it looked like deleting 4,523 lines of code and not looking back.

---

**Next in this series:** "Engineering Complete: Energy, Heat, and System Effectiveness" — where we finally deliver on that "second milestone" promise from 2021 and show you where all that reclaimed development time went.
