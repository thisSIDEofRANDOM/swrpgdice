#!/bin/bash

# SWRPG Dice Roller
# Narrative dice roller for FFG SWRPG system
# tsunamibear <thissideofrandom@gmail.com>
#
#~ Options:
#~   bB   Boost Die (Blue)
#~   sS   Setback Die (Black)
#~   aA   Ability Die (Green)
#~   dD   Difficult Die (Purple)
#~   pP   Proficiency Die (Yellow)
#~   cC   Challenge Die (Red)
#~   fF   Force Die (White)
#~
#~   vV   Verbose Mode (More vVs increase verbosity)
#~   mM   Print dice tables
#~   hH   Print usage and exit
#~
#~   A (#) can be placed infront of any dice symbol above to increase the number of dice of that type
#~   You can declare multiple dice by specifying them multiple times in the argument
#~      Example: 2a3pbb2sv
#~      Absurd Example: b ff 2vsa 4 c2bf17 1v

# General Globals
_VERSION=0.1
_VERBOSE=0
FULL_NAME=$(basename $0)

# Global Dice Arrays
# This is the FFG "Role Map"
# Element 0 is the number of sides on the dice, the other lements contain the math for the symbols that come up
b_array=("6" "_BLANK+=1" "_BLANK+=1" "_SUCCESS+=1" "_SUCCESS+=1,_ADVANTAGE+=1" "_ADVANTAGE+=2" "_ADVANTAGE+=1")
s_array=("6" "_BLANK+=1" "_BLANK+=1" "_FAILURE+=1" "_FAILURE+=1" "_THREAT+=1" "_THREAT+=1")
a_array=("8" "_BLANK+=1" "_SUCCESS+=1" "_SUCCESS+=1" "_SUCCESS+=2" "_ADVANTAGE+=1" "_ADVANTAGE+=1" "_SUCCESS+=1,_ADVANTAGE+=1" "_ADVANTAGE+=2")
d_array=("8" "_BLANK+=1" "_FAILURE+=1" "_FAILURE+=2" "_THREAT+=1" "_THREAT+=1" "_THREAT+=1" "_THREAT+=2" "_FAILURE+=1,_THREAT+=1")
p_array=("12" "_BLANK+=1" "_SUCCESS+=1" "_SUCCESS+=1" "_SUCCESS+=2" "_SUCCESS+=2" "_ADVANTAGE+=1" "_SUCCESS+=1,_ADVANTAGE+=1" "_SUCCESS+=1,_ADVANTAGE+=1" "_SUCCESS+=1,_ADVANTAGE+=1" "_ADVANTAGE+=2" "_ADVANTAGE+=2" "_SUCCESS+=1,_TRIUMPH+=1")
c_array=("12" "_BLANK+=1" "_FAILURE+=1" "_FAILURE+=1" "_FAILURE+=2" "_FAILURE+=2" "_THREAT+=1" "_THREAT+=1" "_FAILURE+=1,_THREAT+=1" "_FAILURE+=1,_THREAT+=1" "_THREAT+=2" "_THREAT+=2" "_FAILURE+=1,_DESPAIR+=1")
f_array=("12" "_DARKSIDE+=1" "_DARKSIDE+=1" "_DARKSIDE+=1" "_DARKSIDE+=1" "_DARKSIDE+=1" "_DARKSIDE+=1" "_DARKSIDE+=2" "_LIGHTSIDE+=1" "_LIGHTSIDE+=1" "_LIGHTSIDE+=2" "_LIGHTSIDE+=2" "_LIGHTSIDE+=2")

# Global Totals
_SUCCESS=0
_FAILURE=0	
_ADVANTAGE=0
_THREAT=0
_TRIUMPH=0
_DESPAIR=0
_LIGHTSIDE=0
_DARKSIDE=0
_BLANK=0

# Help Function
print_help() {
  echo "Usage: ${FULL_NAME} [#][bBsSaAdDpPcCfF] [vV] [mM] [hH]"
  sed -ne 's/^#~//p' ${0}
}

# Default rolls a d6 if no side passed
roll_dice() {
  echo $(((${RANDOM} % ${1:-6})+1))
}

# Print dice map table
print_map() {
  echo "Dice Tables"
  echo "# Boost Dice"; echo ${b_array[@]//_/}
  echo "# Setback Dice"; echo ${s_array[@]//_/}
  echo "# Ability Dice"; echo ${a_array[@]//_/}
  echo "# Difficulty Dice"; echo ${d_array[@]//_/}
  echo "# Proficiency Dice"; echo ${p_array[@]//_/}
  echo "# Challenge Dice"; echo ${c_array[@]//_/}
  echo "# Force Dice"; echo ${f_array[@]//_/}
}

# Verbose counts for rolls
print_verbose() {
  echo "Totals"
  echo "Success: ${_SUCCESS}"
  echo "Failure: ${_FAILURE}"
  echo "Advantage: ${_ADVANTAGE}"
  echo "Threat: ${_THREAT}"
  echo "Triumph: ${_TRIUMPH}"
  echo "Depair: ${_DESPAIR}"
  echo "Lightside: ${_LIGHTSIDE}"
  echo "Darkside: ${_DARKSIDE}"
  echo "Blank: ${_BLANK}"
}

# Main result function, handles game logic
print_results() {
  # Game logic - Failure and Success cancel, Advantage and Threat cancel
  local SF=$((_SUCCESS-_FAILURE))
  local AT=$((_ADVANTAGE-_THREAT))

  # Success/Failure
  if [[ ${SF} -le 0 ]]; then
    echo -n "Failed roll by: ${SF#-} "
  elif [[ ${SF} -gt 0 ]]; then
    echo -n "Succeeded roll by: ${SF} "
  fi
  
  # Advantage/Threat
  if [[ ${AT} -lt 0 ]]; then
    echo "with ${AT#-} threat"
  elif [[ ${AT} -gt 0 ]]; then
    echo "with ${AT} advantage"
  else
    echo
  fi

  # Trimphs
  if [[ ${_TRIUMPH} -gt 0 ]]; then echo "Rolled ${_TRIUMPH} Triumph!"; fi

  # Despairs
  if [[ ${_DESPAIR} -gt 0 ]]; then echo "Rolled ${_DESPAIR} Despair!"; fi

  # Light side pips
  if [[ ${_LIGHTSIDE} -gt 0 ]]; then echo "Rolled ${_LIGHTSIDE} light side points"; fi

  # Dark side pips
  if [[ ${_DARKSIDE} -gt 0 ]]; then echo "Rolled ${_DARKSIDE} dark side points"; fi
}

# Check for an argument or print usage
if [ ${#} -lt 1 ] || [[ ${@} =~ [hH] ]]; then
  print_help
  exit
fi  

# Check for verbose switch
if [[ ${@} =~ [vV] ]]; then _VERBOSE=1; fi

# Check for map switch
if [[ ${@} =~ [mM] ]]; then print_map; echo; fi

# Main 
# Convert arguments for parsing. Order shouldn't matter
for arg in $(sed 's/\([a-zA-Z]\)/&\n/g; s/\([0-9]\+\)/&\n/g' <<< ${@// /}); do

  # If verbose flag, move to next argument
  if [[ ${arg} == [vV] ]]; then ((_VERBOSE++)); continue; fi

  # If map flag, move to next argument
  if [[ ${arg} == [mM] ]]; then continue; fi

  # If arg is a number set to number of dice for next die
  if [[ ${arg} =~ ^[0-9]+$ ]]; then
    NUMDICE=${arg}
    continue
  # If no number of die then assume one
  elif [[ ! ${NUMDICE} ]]; then
    NUMDICE=1
  fi

  # Exit if we encounter an unknown dice type
  if [[ ${arg} != [bBsSaAdDpPcCfF] ]]; then
    echo -e "Encountered unknown argument in equation: ${arg}\n"
    print_help
    exit
  fi

  while [[ ${NUMDICE} -gt 0 ]]; do
    # Set dynamic array name for indirection. Converts to lowercase
    DICE="${arg,}_array"
  
    # Debug Line
    if [[ ${_VERBOSE} -gt 0 ]]; then echo -n "Rolling ${DICE:0:1} dice > "; fi
    
    # Set our result after the role for further indirection calls
    DICE="${DICE}[$(roll_dice ${!DICE[0]})]"

    # Debug Line
    if [[ ${_VERBOSE} -gt 0 ]]; then echo "Rolled: ${DICE:7} mapping to > ${!DICE//_/}"; fi

    # Process roll actions from array return indirectly
    ((${!DICE}))

    # Subtract from dice left to role
    ((NUMDICE--))

    # Cleanup dice
    unset DICE
  done

  # Cleanup Number of dice
  unset NUMDICE
done

# Print final results
if [[ ${_VERBOSE} -gt 1 ]]; then echo; if [[ ${_VERBOSE} -gt 2 ]]; then print_verbose; echo; fi; fi

print_results
