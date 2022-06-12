---
layout: post
title: Working on simple AI commands
subtitle: adding some RTS flavor to the GM screen
tags: [gm,AI,technology]
author: amir
---
I open the GM screen, choose a ship, right click somewhere on the radar near that ship, and then the ship begins turning and moving towards the point I clocked. The ship gracefully slows down as it reaches its destination and I am in developer heaven: success on first try! I love it when that happens. So rare. But wait - why is the ship not stopping? why is it going back in circles? no, in spirals! it's moving away? why is it drifting into space?

At this point I've realized that it was going to take a while. These movement formulas can get extremely trickey. So, I made myself a cup of coffee and sat down to write about it in this blog. Yes. I procrastinate. 

<iframe width="640" height="360" src="/assets/img/goto-command-bug.webm" frameborder="0"> </iframe>

## The feature
I'm working on some basic commands the GM can give spaceships. Now that we are open source, you can see the issue [here](https://github.com/starwards/starwards/issues/552).
My design for this feature is that whenever the GM issues a command to a ship, the AI logic of that ship (we call it "bot") will be completely replaced by the new command.

## The Jouster Bot
The first AI logic was already written a while ago: it is the aggressive attack bot of our fighter. I named it "Jouster" because when you pit two bots of this kind against each other they tend to charge at each other at top speed while firing, then slow down, turn around and charge again. It took me a very long while to write and it involved a lot of tiresom calculations, and a tedious debugging process.
However this bot is not connected to any interactive command. The jouster bot can only be configured in code, when defining a new spaceship. 
This bot would have made a good candidate for our first command ("attack"). However...

### Why the jouster is not the best choice for the first command
By itself, the jouster bot simply attacks the current ship's target. In order to make it a GM command, I need to prefix it with some logic to set the target - and what if the GM did not click on a ship, but on open space? or an astroid? or told the ship to attack itself? these things are not overly hard to deal with, but enough to complicate the solutuion a bit more than is ideal for a "first of its kind" solution. 
Also on the product level, if we added an attack command we would immediately need a command to tell the fiesty jouster to stand down - removing the bot logic from the ship when the GM wants to call off an atack.

## The first command Bot - go to
The simplest command to issue as a GM would then not be to attack a target, but rather to go to a certain place on the map. This involves less "moving parts" as any place on the map is a valid target. Moreover, we can use the "go to" command to position units, but also as a quick way to disable any previous order - telling a unit to go to where it is already positioned is effectively telling it to "stand down". It can also serve as "Run Away". Hey, at least that's how I play RTS games.

## First attempt
Naively, I thought I'll just borrow some code parts from the jouster. The parts where it aim at the target and closes the distance should do the trick, right? I thought I'd leave more complex problems like [Pathfinding](https://en.wikipedia.org/wiki/Pathfinding) for a later stage, and just do a point-to-point blind movement. When the spaceship reaches the target position, the bot should just remove itself from the ship, so that the ship takes no further actions of its own until a new command is issued. Dead simple, right? 

Well, as the beginning of this post suggested, things are seldom *that* simple. 

However, I am happy to report that after procrastinating by recording and writing all the above text, I got lucky with one of those inspiration moments, and the solution just popped into my head.

## Second attempt
It dawned on me, that the code where the bot removes itself was incomplete: the ship's thrusters and rotation are left as-is, and this is why it's drifting in those funny circles. I quickly added clean-up instructions just before the bot is removed, so that the last command of the bot is to activate auto-pilot and order it to reach zero rotation and velocity.

...And it worked :)



