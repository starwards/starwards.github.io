---
layout: post
title: Let there be thrusters
subtitle: Re-modeling the maneuvering system so it can take damage
tags: [damage, fighter, thruster, technology]
author: amir
---

## context
As part of the 2nd milestone ([damage system]({% link _posts/2021-04-03-damage-system.md %})), we're going to add malfunctions to different ship systems. The thing is, I didn't model the systems all that well and gave most of the ship an abstract, calculation-centric model. The ship has parameters and formulas that define how it moves, but no reference to the internal parts that cause the movement, and their interactions. 

## Refactoring out the thrusters
To apply the new feature (maneuvering malfunctions) efficiently, I would need to do some preliminary work. I'd need to extract the maneuvering from the rest of the ship's model, all the while not changing how it behaves. This action is called ["code refactoring"](https://refactoring.com/), and it's how code should evolve as new requirements amass.

 Until now, when a ship should have moved, it directly traded energy and fuel for velocity in any desired direction. So I've moved the code in charge of velocity generation (moving forward, backward, left, and right) to a new kind of *object* called thruster. Each thruster is capable of generating movement in a single direction (opposite to its angle). Using thruster, when a ship should move, the desired velocity is broken down to the action required from each thruster and passed as commands to the thrusters. Each thruster then trades energy and fuel for velocity in its constant direction. The breaking down of instructions involves some algebra, and it took a while to get it just right. But now that trusters are a separate technical entity, We can refer to their properties, discuss different kinds of thrusters, etc. 

Specifically, we can interfere with their activity: separately and directly.

## To kill a thruster
Once I got the ship to work smoothly with thrusters, It took almost no time to add an "is this thing broken" property to each thruster (defaults to `false`), that when set to `true`, it prevents the thruster from doing its job. I figured it would make for a perfect first malfunction, and I was eager to try out the result. I had the ship start the game with its starboard (that's "right" in ship-directions) thruster broken and started a new game.

The effect was what you'd expect: when the ship is at rest, nothing special happening. Moving backward and forward works as usual. But you can't move to the left, and once you move the ship to the right, it doesn't stop moving. Nothing in it can push left. So there it was: kill the right engine, get a drift to the right. So neat.

> ### A word about the piloting automation
> Before continuing with the story, let's elaborate a little about the piloting automation of the ship. The ship's movement helm (the part controlling forward, backward, left, and right movements) has two relevant modes which the pilot can switch between:
>  - `Velocity` mode: In which the helm's state is the desired ship velocity. The piloting computer will measure the ship's actual speed, read the helm's state, and if there is a gap between the two, it will issue a command to the ship (which will now translate to each thruster). That is the default piloting mode, and the recommended way for pilots to fly the ship. In this mode, when the helm rests, the ship will aim to reach 0 velocity, and the thrusters will work as needed. 
>  - `Direct` mode: The helm's state translates directly to ship movement commands. This mode was the original mode (before the piloting computer ever existed). It is hard to control the ship in this mode. We kept it around for a long while with the thought that we will find a use for it someday, as it has an engaging, rough, and realistic feeling to it. Perhaps, if the piloting computer malfunctions, or if there is a reason for switching it off, we will find a good use for this mode. In this mode, when the helm rests, the thrusters are idle. The ship will continue its current velocity. 

## So now what
Being the test pilot in my little experiment, I wanted to test how I can manage the drift under these conditions. I hypothesized that turning the ship 90 degrees to any direction while aiming for 0 velocity should pretty much halt it - as the front/back thrusters are operational and can quickly stop the ship if pointed opposite to the direction of the drift. Much to my surprise, this approach did not work: as the ship rotated, its movement also rotated, so the ship was always moving starboards.

How Odd. 

At first, I thought I encountered a bug. These things happen a lot during development, though I did not expect it to happen with something as solid as the physics engine at this stage. So I had to assume something was actively pushing the ship to change the direction of the drift. And the only thing that can actively do that, was the ship's thrusters.

## How things turn
So it appears that, due to the dynamics of the rotation, when the ship's thrusters aim for 0 velocity while rotating with a broken thruster, they don't reduce the velocity of the drift by much, but rather change the direction of velocity. The ship's velocity reduced by around 0.4% per second, which is almost nothing. 

> I assume the dynamics to go something like this: rotating the ship clockwise, the drift moves slightly from right to front-right (by a fraction): the front thruster pushes backward to negate some of it: there is mostly a backward drift: the back thruster pushes forward: between them, they almost balance out, with a slight advantage towards the backward drift, which makes the front-right drift turn back into a right drift. Or in simple terms: the ship rotates too slow compared to the power of the thrusters aiming for 0 velocity during the turn. by over-reacting to the part of the drift they can negate, the thrusters effectively keep the drift to the right of the ship.

Having realized this, I've tried switching the helm to `Direct` mode, rotating the ship 90 degrees, and then switching the helm back to `Velocity` mode. This way, the thrusters won't interfere during the round, and will spring into automatic action only after the rotation is over. I hoped that as long as the drift is not near the direction of the broken thruster, this should work. And, so it did! The drift was negated in a matter of seconds. Ah, the sweet taste of things coming together! we now have a realistic and practical use for the `Direct` mode, as well as a short protocol for managing drift with a dead thruster. 

## What's next
Next on my agenda is GM controllers for the "is this thing broken" property in each thruster in each ship, and probably adding one of these to the chaingun as well. Then, I will continue to add armor and hit zones and tie it all together as per [the design]({% link _posts/2021-04-03-damage-system.md %}).





