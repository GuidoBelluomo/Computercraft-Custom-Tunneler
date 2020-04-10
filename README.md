# Computercraft-Custom-Tunneler
A computercraft lua script for a custom tunneler supporting filters and different dig directions

## Preparing the Turtle
Place the turtle facing a crate, all digging will be done away from the crate.

## Crate Setup
All fuel should be placed in the first slots of the crate, I haven't had it run on more than two stacks of fuel in a crate, yet. More than two stacks may cause some issues as while unloading itself it might decide to place a non-fuel item before the other fuel stacks, rendering automatic refuel useless once one of the stacks depletes.

Otherwise, it should support up to 16 fuel stacks.

## General Behaviour
The turtle will refuel from the crate and then turn around, starting to dig in the specified direction. It will dig until it has just enough fuel to reach the starting crate, until all slots are full, or until it's finished digging its assigned area.

If the turtle can't keep digging, it will go back to the crate and attempt unloading all its inventory and refuel, to then resume its work. If it can't resume, it will hang at the crate until conditions are met. If it meets an obstacle, it will patiently wait for it to move.

## Hidden Behaviour
The turtle will save its state in a file as well as a turtle startup file, so that when the chunk reloads or the server restarts it should be able to resume work. Provided its filesystem gets properly saved by the server.

The state file actually proves very handy for debugging reasons and changing the settings after stopping the turtle, it's called "**tunnelingProgress**" and is saved in the same directory as the script. I will not document this file yet.

## Emergency Stop
Right click on it and hold **CTRL+T** to terminate the script, this works for all scripts

## Dig Directions
The turtle supports three digging directions:
* Up
* Down
* Forward

Each of them will swap the movement axes so they respond to different command dimensions

#### Digging Up
Length -> Forward
Width -> Right
Depth -> Up

#### Digging Down
Length -> Forward
Width -> Right
Depth -> Down

#### Digging Forward
Length -> Right
Width -> Up
Depth -> Forward

## Running the command
Running the command with "**help**", no parameters, or wrong parameters, prints out the usage instructions.

#### Standard syntax
Length Width Depth *DigDirection*

_DigDirection = Either "**Up**", "**Down**", or "**Forward**"_

#### --resume
If the turtle stops for whatever reason, you can attempt resuming by running it with just this parameter.

#### -filter x,...
This option adds the item IDs contained afterwards (in a comma-separated list) to the filter.

_Example: minecraft:dirt,minecraft:sand_

#### -filter junk
This option runs the turtle in Blacklist mode, filtering all the junk blocks I could think of.

#### -unfilter x,...
This option removes the item IDs contained afterwards (in a comma-separated list) from the filter.

_Example: minecraft:dirt,minecraft:sand_

#### -unfilter all
This option clears the filter. Unsure why I added this, as the filter is empty by default.

#### -filtermode FilterMode
_FilterMode = Either "**Blacklist**", "**Whitelist**", or "**None**"_

Blacklist mode will toss out anything included in the filter
Whitelist mode will toss out anything not included in the filter
None mode will stop filtering altogether.

_Whhen running whitelist mode, make sure to whitelist the fuel you're using. Coal is **minecraft:coal**_
