# swrpgdice
Bash dice roller for Fantasy Flight Games Star Wars RPG

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
bash swdice.sh b ff 2vsa 4 c2bf17 1vv
Rolling b dice > Rolled: [3] mapping to > ADVANTAGE+=2
Rolling f dice > Rolled: [9] mapping to > LIGHTSIDE+=1
Rolling f dice > Rolled: [2] mapping to > DARKSIDE+=1
Rolling s dice > Rolled: [6] mapping to > THREAT+=1
Rolling s dice > Rolled: [5] mapping to > THREAT+=1
Rolling a dice > Rolled: [3] mapping to > SUCCESS+=1
Rolling c dice > Rolled: [4] mapping to > FAILURE+=2
Rolling c dice > Rolled: [11] mapping to > THREAT+=2
Rolling c dice > Rolled: [1] mapping to > BLANK+=1
Rolling c dice > Rolled: [12] mapping to > DESPAIR+=1
Rolling b dice > Rolled: [6] mapping to > SUCCESS+=1
Rolling b dice > Rolled: [3] mapping to > ADVANTAGE+=2
Rolling f dice > Rolled: [1] mapping to > DARKSIDE+=1

Totals
Succes: 2
Failure: 2
Advantage: 4
Threat: 4
Triumph: 0
Depair: 1
Lightside: 1
Darkside: 2
Blank: 1

Failed roll by: 0 
Rolled 1 Despair!
Rolled 1 light side points
Rolled 2 dark side points
```
