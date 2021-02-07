---
layout: post
title: The first game design milestone
subtitle: Our decision on the first focal point of game experience
tags: [dogfight, product, game-design]
---

## The Plateau
After laying the technical foundations, the project was stuck. We had everything technically required for the next phase, but we weren't sure what that next phase should be. 

At that point, we could already simulate a basic scenario and render it in 2D on a browser window. We had demonstration scenarios of collisions, firing projectiles, flying around, drag-n-drop objects in real-time, and that's about it. We hardly made any user experience progress, so the gap between what we had and a usable LARP space simulator seemed vast, not only in functionality but also in design and knowledge. 

And, in sharp contradiction with how stuck the project was, we kept coming up with mechanics ideas for ship systems, guns, cyber warfare, not to mention a myriad of technical "engineering" scenarios and devices, and so on.

## Enter Game Design
We talked and talked until we figured that it was time to take the first steps into the game design. We had a high-level model of the game design (an SBS inspired mostly by our fork of EmptyEpsilon), but we hadn't got into the nuts and bolts yet. We needed a milestone to focus our efforts.

We knew that whichever parts we design earlier will serve as the foundation for following design choices, so we looked for the one that best fits these criteria:

1. It should be a primary game mechanic (loose definition: "activity players perform again and again that directly helps solving challenges that lead to the desired end state")
2. We have a good grasp of how it should feel, without assuming how other parts should feel
3. Mostly independent of other mechanisms that we have not yet designed
4. The design of other mechanisms should derive from it 
5. We should be able to package it as a complete experience with as little overhead as possible so that we can test-play it

In other words, the first game design milestone should be the thing we are most knowledgeable about, that we can isolate as a mini-product, and will teach us the most.

Easy peasy! The first game design milestone should be the smallest, most basic combat scenario: a dogfight.

## A Dogfight
By dogfight, we meant combat between two space fighters of the same model, each driven by a single pilot, each trying to hit the other before being hit herself. 
Designing a dogfight will drive the design and balancing of steering and maneuvering capabilities, engagement ranges, aiming systems, ballistics, and so on. That will later allow us to branch in many other directions: more complex combat scenes, larger ships, 3D view, advanced GM capabilities, etc.

And so we started designing the actual game.