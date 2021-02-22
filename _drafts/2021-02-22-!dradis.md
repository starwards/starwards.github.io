---
layout: post
title: DRADIS
subtitle: 
tags: []
---
DRADIS (https://en.battlestarwikiclone.org/wiki/DRADIS) - combines all sensor data and intelligence into a real-time battle map.

Tactical radar, for example, is displaying DRADIS.

Auto classification of radar blips is stupid - Detects only crude types by basic rules ('asteroid' by default, 'vessel' if it has a transponder, 'projectile' if it's fast) and some basic raw info (transponder data, velocity, radius, etc.).

The science crew analyzes signals (heat, electromagnetic, radio, etc.) and classifies the blips accordingly. 

The classification updates all screens displaying the DRADIS in real-time. So if science classified something as having torpedos, the torpedo's firing arch is added for this blip in DRADIS.

Classification is a process of eliminating components from the signature of the signal. For example,  detecting the reactor first because its signal signature is the most recognizable, then the impulse system, then it's possible to deduce the ship class, etc.


