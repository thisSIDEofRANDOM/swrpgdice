# swrpgdice
Bash dice roller for Fantasy Flight Games Star Wars RPG
## Usage
```
Usage: swdice.sh [#][bBsSaAdDpPcCfF] [vV] [mM] [hH]
 Options:
   bB   Boost Die (Blue)
   sS   Setback Die (Black)
   aA   Ability Die (Green)
   dD   Difficult Die (Purple)
   pP   Proficiency Die (Yellow)
   cC   Challenge Die (Red)
   fF   Force Die (White)

   vV   Verbose Mode (More vVs increase verbosity)
   mM   Print dice tables
   hH   Print usage and exit

   A (#) can be placed infront of any dice symbol above to increase the number of dice of that type
   You can declare multiple dice by specifying them multiple times in the argument
      Example: 2a3pbb2sv
      Absurd Example: b ff 2vsa 4 c2bf17 1v
```
## Example
```
bash swrpgdice.sh 3ap3dcf vv
Rolling a dice > Rolled: [2] mapping to > SUCCESS+=1
Rolling a dice > Rolled: [2] mapping to > SUCCESS+=1
Rolling a dice > Rolled: [6] mapping to > ADVANTAGE+=1
Rolling p dice > Rolled: [12] mapping to > SUCCESS+=1,TRIUMPH+=1
Rolling d dice > Rolled: [6] mapping to > THREAT+=1
Rolling d dice > Rolled: [7] mapping to > THREAT+=2
Rolling d dice > Rolled: [5] mapping to > THREAT+=1
Rolling c dice > Rolled: [12] mapping to > FAILURE+=1,DESPAIR+=1
Rolling f dice > Rolled: [6] mapping to > DARKSIDE+=1

Totals
Succes: 3
Failure: 1
Advantage: 1
Threat: 4
Triumph: 1
Depair: 1
Lightside: 0
Darkside: 1
Blank: 0

Succeeded roll by: 2 with 3 threat
Rolled 1 Triumph!
Rolled 1 Despair!
Rolled 1 dark side points
```
## Dice Map
```
bash swrpgdice.sh m
Dice Tables
# Boost Dice
6 BLANK+=1 BLANK+=1 SUCCESS+=1 SUCCESS+=1,ADVANTAGE+=1 ADVANTAGE+=2 ADVANTAGE+=1
# Setback Dice
6 BLANK+=1 BLANK+=1 FAILURE+=1 FAILURE+=1 THREAT+=1 THREAT+=1
# Ability Dice
8 BLANK+=1 SUCCESS+=1 SUCCESS+=1 SUCCESS+=2 ADVANTAGE+=1 ADVANTAGE+=1 SUCCESS+=1,ADVANTAGE+=1 ADVANTAGE+=2
# Difficulty Dice
8 BLANK+=1 FAILURE+=1 FAILURE+=2 THREAT+=1 THREAT+=1 THREAT+=1 THREAT+=2 FAILURE+=1,THREAT+=1
# Proficiency Dice
12 BLANK+=1 SUCCESS+=1 SUCCESS+=1 SUCCESS+=2 SUCCESS+=2 ADVANTAGE+=1 SUCCESS+=1,ADVANTAGE+=1 SUCCESS+=1,ADVANTAGE+=1 SUCCESS+=1,ADVANTAGE+=1 ADVANTAGE+=2 ADVANTAGE+=2 SUCCESS+=1,TRIUMPH+=1
# Challenge Dice
12 BLANK+=1 FAILURE+=1 FAILURE+=1 FAILURE+=2 FAILURE+=2 THREAT+=1 THREAT+=1 FAILURE+=1,THREAT+=1 FAILURE+=1,THREAT+=1 THREAT+=2 THREAT+=2 FAILURE+=1,DESPAIR+=1
# Force Dice
12 DARKSIDE+=1 DARKSIDE+=1 DARKSIDE+=1 DARKSIDE+=1 DARKSIDE+=1 DARKSIDE+=1 DARKSIDE+=2 LIGHTSIDE+=1 LIGHTSIDE+=1 LIGHTSIDE+=2 LIGHTSIDE+=2 LIGHTSIDE+=2
```
