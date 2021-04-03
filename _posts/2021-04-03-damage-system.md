---
layout: post
title: Designing a damage system
subtitle: Conclusions from a design meeting about ship damage
tags: [damage, product, game-design]
comments: true
---

## The TPK issue
LARP organizers usually need to control TPK ([Total Party Kill](https://dnd4.fandom.com/wiki/Total_party_kill)) situations. In spaceship LARPs, this means controlling when the game rules can't automatically destroy ships. Destroying the players' spaceship, for example, is usually left as a game master's decision, as it might mean the untimely end of the game.

## The points issue
We don't like the Hit / Damage points approach. Points represent the general health of a body in an opaque way. While a helpful tool, in the real world, we seldomly have such useful abstractions. It's a relic we inherited from the ancestor of tabletop roleplaying games, human-operated combat simulations.

Abstracting technical data points into a single-dimensional metric can be something for players to do themselves. We like having such small tasks because they can be a foundation for other aspects of the game. For example, while an engineer can look at a myriad of technical issues and summarize a short managerial report (then call out "core at eighty percent! she can't take much longer captain!"), a combat pilot may not be able to make sense of them. That builds the niche aspect: different players view the same thing through different lenses and, as a result, respond differently. 

## Directing the damage to consequences
So, what will happen to the player ship as it takes damage? There must be negative consequences, or the core tactical incentive is lost.
We've decided we want the damage to cause system malfunctions that may limit and handicap the players' spaceship but not destroy it.

System malfunctions roughly split into two groups:
1. Soft problems: increase chances of more malfunctions but do not hinder the system's performance.
2. Hard problems: hinder the system's performance

### Damage report
![getting a damage report](/assets/img/damage-report.jpg){: .float-right :}
We like the idea of Damage Reports (inspired by [Thorium](https://thoriumsim.com/docs/damage_reports_config/)). When there is a system malfunction, the ship's computer "magically" prompts the players with a damage report containing: the reason for malfunction, how it affects the system, and the way(s) to fix or mitigate it. That provides more opportunities for player tasks around the same game event, and as we mentioned earlier, we like player tasks.

### Diagnosis
We also want to let some players diagnose the problem before a damage report is ready for all to see.

That can have two flavors: 
 - proactive-diagnosis: predicting malfunctions before a negative effect on the ship is evident 
 - reactive-diagnosis: analyzing the problem faster than the ship's computer

In proactive-diagnosis, a technician may ask the computer to analyze a system for irregularities and errors. That can happen in a routine system test or by an alert technician when they see some detail out of place.

We think about proactive-diagnosis as the primary method for discovering Soft problems.

## Structure Regions
We intend to split the ship into several structure regions (SR). 4 SRs for spaceships, 2 SRs for fighters. Each SR hosts several systems, and a system can be hosted in more than one SR (for example, maneuvering is hosted in several SRs as it has thrusters on opposite sides of the ship). When an SR gets hit, the damage affects the systems it hosts. There could be redundancies between SRs, so if some part fails, they may have backups in other SRs (for example, having redundant antennas).

## Armor
![battletech armor diagram](/assets/img/battletech-armor-diagram.jpg){: .float-right :}
We don't like the idea of energy shields. We prefer having armor instead. This solution draws inspiration from "Battletech": armor is a system that absorbs damage before any other system in the SR. Different kinds of armor have are effective against various types of damage. A fully functional armor can absorb 100% of the damage type it is designed to withstand. 
In the armor system, malfunctions are breaches in the armor. The more breached the armor, the larger the chances of it failing to absorb damage from an incoming attack.

Armor malfunctions are different from other system malfunctions in two ways:
1. Fixing armor malfunctions is done by a shipyard, not by regular crew activities. It will require docking, which is a potential for a significant game event.
2. Armor handles damage orders of magnitude better than internal systems.

When an SR takes damage, there is a process of resolving the damage:
1. Armor processes damage. The armor may be affected by the damage taken. The armor calculates if the damage passed through one of its breaches, etc. Some or all of the damage then propagates to the internal parts of the region. 
2. The propagated damage then hits every system in the region. Each system resolves it according to its logic.

## Action Items
 - write problems "Bank" per system. soft, hard. write down fluff and effects.
 - calculate the propagation model of malfunctions (meaning, how "soft" increases the chances of more problems) 

