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

# Initialize die totals
_SUCCESS=0
_ADVANTAGE=0
_TRIUMPH=0
_DESPAIR=0
_LIGHTSIDE=0
_DARKSIDE=0
_BLANK=0

# Help Function
function usage() {
  echo "Usage: ${FULL_NAME} [#][bBsSaAdDpPcCfF] [vV] [mM] [hH]"
  sed -ne 's/^#~//p' ${0}
}

function debug() {
  [[ ${_VERBOSE} -le 0 ]] && return
  echo "DEBUG ($(date +%F_%T.%N)): ${@}"
}

function error() {
  echo "${@}" >&2
}

function colorize() {
  # Plagiarized the hell out of this function from Mr. Howard:
  # Src: https://github.com/StafDehat/scripts/blob/master/colors.sh
  local K R G Y B P C W                  # Colored
  local EMK EMR EMG EMY EMB EMP EMC EMW  # Bold & colored
  local NORMAL
  local color="${1}"

  K="\033[0;30m"    # black
  R="\033[0;31m"    # red
  G="\033[0;32m"    # green
  Y="\033[0;33m"    # yellow
  B="\033[0;34m"    # blue
  P="\033[0;35m"    # purple
  C="\033[0;36m"    # cyan
  W="\033[0;37m"    # white
  EMK="\033[1;30m"
  EMR="\033[1;31m"
  EMG="\033[1;32m"
  EMY="\033[1;33m"
  EMB="\033[1;34m"
  EMP="\033[1;35m"
  EMC="\033[1;36m"
  EMW="\033[1;37m"
  NORMAL=`tput sgr0 2> /dev/null`

  shift 1
  case "${color}" in 
    "black")	echo -e "${K}${@}${NORMAL}";;
    "red")	echo -e "${R}${@}${NORMAL}";;
    "green")	echo -e "${G}${@}${NORMAL}";;
    "yellow")	echo -e "${Y}${@}${NORMAL}";;
    "blue")	echo -e "${B}${@}${NORMAL}";;
    "purple")	echo -e "${P}${@}${NORMAL}";;
    "cyan")	echo -e "${C}${@}${NORMAL}";;
    "white")	echo -e "${W}${@}${NORMAL}";;
    "BLACK")	echo -e "${EMK}${@}${NORMAL}";;
    "RED")	echo -e "${EMR}${@}${NORMAL}";;
    "GREEN")	echo -e "${EMG}${@}${NORMAL}";;
    "YELLOW")	echo -e "${EMY}${@}${NORMAL}";;
    "BLUE")	echo -e "${EMB}${@}${NORMAL}";;
    "PURPLE")	echo -e "${EMP}${@}${NORMAL}";;
    "CYAN")	echo -e "${EMC}${@}${NORMAL}";;
    "WHITE")	echo -e "${EMW}${@}${NORMAL}";;
    *)          echo "${@}";;
  esac
}

# Default rolls a d6 if no side passed
roll_dice() {
  local numSides="${1:-6}"
  echo $(( (RANDOM % numSides) + 1 ))
}

# Print dice map table
print_map() {
  cat <<EOF
Dice Tables
$( colorize BLUE   "# Boost Dice:       ${b_array[@]//_/}" )
$( colorize BLACK  "# Setback Dice:     ${s_array[@]//_/}" )
$( colorize GREEN  "# Ability Dice:     ${a_array[@]//_/}" )
$( colorize PURPLE "# Difficulty Dice:  ${d_array[@]//_/}" )
$( colorize YELLOW "# Proficiency Dice: ${p_array[@]//_/}" )
$( colorize RED    "# Challenge Dice:   ${c_array[@]//_/}" )
$( colorize WHITE  "# Force Dice:       ${f_array[@]//_/}" )
EOF
  echo
}

# Verbose counts for rolls
print_verbose() {
  cat <<EOF
Totals
Success:   ${_SUCCESS}
Advantage: ${_ADVANTAGE}
Triumph:   ${_TRIUMPH}
Despair:   ${_DESPAIR}
Lightside: ${_LIGHTSIDE}
Darkside:  ${_DARKSIDE}
Blank:     ${_BLANK}
EOF
}

# Main result function, handles game logic
print_results() {
  local str=""
  # Success/Failure
  if [[ ${_SUCCESS} -le 0 ]]; then
    str="Failed roll by: ${_SUCCESS#-} "
  elif [[ ${_SUCCESS} -gt 0 ]]; then
    str="Succeeded roll by: ${_SUCCESS} "
  fi
  # Advantage/Threat
  if [[ ${_ADVANTAGE} -lt 0 ]]; then
    str+="with ${_ADVANTAGE#-} threat"
  elif [[ ${_ADVANTAGE} -gt 0 ]]; then
    str+="with ${_ADVANTAGE} advantage"
  fi
  echo "${str}"
  [[ ${_TRIUMPH}   -gt 0 ]] && echo "Rolled ${_TRIUMPH} Triumph!"
  [[ ${_DESPAIR}   -gt 0 ]] && echo "Rolled ${_DESPAIR} Despair!"
  [[ ${_LIGHTSIDE} -gt 0 ]] && echo "Rolled ${_LIGHTSIDE} light side points"
  [[ ${_DARKSIDE}  -gt 0 ]] && echo "Rolled ${_DARKSIDE} dark side points"
}

function roll_boost() {
  local numDice=${1}
  local numSides=6
  local thisRoll=0
  debug "Rolling ${numDice} ${FUNCNAME#roll_} dice:"
  for x in $( seq 1 ${numDice} ); do
    thisRoll=$(roll_dice ${numSides})
    debug "Just rolled a ${thisRoll} on ${FUNCNAME#roll_} dice"
    case "${thisRoll}" in
      1) _BLANK=$((_BLANK+1));;
      2) _BLANK=$((_BLANK+1));;
      3) _SUCCESS=$((_SUCCESS+1));;
      4) _SUCCESS=$((_SUCCESS+1))
         _ADVANTAGE=$((_ADVANTAGE+1));;
      5) _ADVANTAGE=$((_ADVANTAGE+2));;
      6) _ADVANTAGE=$((_ADVANTAGE+1));;
      *) error "Apparently math is broken."
         exit 1;;
    esac
  done
}

function roll_setback() {
  local numDice=${1}
  local numSides=6
  debug "Rolling ${numDice} ${FUNCNAME#roll_} dice:"
  for x in $( seq 1 ${numDice} ); do
    case "$(roll_dice ${numSides})" in
      1) _BLANK=$((_BLANK+1));;
      2) _BLANK=$((_BLANK+1));;
      3) _SUCCESS=$((_SUCCESS-1));;
      4) _SUCCESS=$((_SUCCESS-1));;
      5) _ADVANTAGE=$((_ADVANTAGE-1));;
      6) _ADVANTAGE=$((_ADVANTAGE-1));;
      *) error "Apparently math is broken."
         exit 1;;
    esac
  done
}

function roll_ability() {
  local numDice=${1}
  local numSides=8
  debug "Rolling ${numDice} ${FUNCNAME#roll_} dice:"
  for x in $( seq 1 ${numDice} ); do
    case "$(roll_dice ${numSides})" in
      1) _BLANK=$((_BLANK+1));;
      2) _SUCCESS=$((_SUCCESS+1));;
      3) _SUCCESS=$((_SUCCESS+1));;
      4) _SUCCESS=$((_SUCCESS+2));;
      5) _ADVANTAGE=$((_ADVANTAGE+1));;
      6) _ADVANTAGE=$((_ADVANTAGE+1));;
      7) _SUCCESS=$((_SUCCESS+1))
         _ADVANTAGE=$((_ADVANTAGE+1));;
      8) _ADVANTAGE=$((_ADVANTAGE+2));;
      *) error "Apparently math is broken."
         exit 1;;
    esac
  done
}

function roll_difficulty() {
  local numDice=${1}
  local numSides=8
  debug "Rolling ${numDice} ${FUNCNAME#roll_} dice:"
  for x in $( seq 1 ${numDice} ); do
    case "$(roll_dice ${numSides})" in
      1) _BLANK=$((_BLANK+1));;
      2) _SUCCESS=$((_SUCCESS-1));;
      3) _SUCCESS=$((_SUCCESS-2));;
      4) _ADVANTAGE=$((_ADVANTAGE-1));;
      5) _ADVANTAGE=$((_ADVANTAGE-1));;
      6) _ADVANTAGE=$((_ADVANTAGE-1));;
      7) _ADVANTAGE=$((_ADVANTAGE-2));;
      8) _SUCCESS=$((_SUCCESS-1))
         _ADVANTAGE=$((_ADVANTAGE+2));;
      *) error "Apparently math is broken."
         exit 1;;
    esac
  done
}

function roll_proficiency() {
  local numDice=${1}
  local numSides=12
  debug "Rolling ${numDice} ${FUNCNAME#roll_} dice:"
  for x in $( seq 1 ${numDice} ); do
    case "$(roll_dice ${numSides})" in
      1) _BLANK=$((_BLANK+1));;
      2) _SUCCESS=$((_SUCCESS+1));;
      3) _SUCCESS=$((_SUCCESS+1));;
      4) _SUCCESS=$((_SUCCESS+2));;
      5) _SUCCESS=$((_SUCCESS+2));;
      6) _ADVANTAGE=$((_ADVANTAGE+1));;
      7) _SUCCESS=$((_SUCCESS+1))
         _ADVANTAGE=$((_ADVANTAGE+1));;
      8) _SUCCESS=$((_SUCCESS+1))
         _ADVANTAGE=$((_ADVANTAGE+1));;
      9) _SUCCESS=$((_SUCCESS+1))
         _ADVANTAGE=$((_ADVANTAGE+1));;
      10) _ADVANTAGE=$((_ADVANTAGE+1));;
      11) _ADVANTAGE=$((_ADVANTAGE+1));;
      12) _SUCCESS=$((_SUCCESS+1))
          _TRIUMPH=$((_TRIUMPH+1));;
      *) error "Apparently math is broken."
         exit 1;;
    esac
  done
}

function roll_challenge() {
  local numDice=${1}
  local numSides=12
  debug "Rolling ${numDice} ${FUNCNAME#roll_} dice:"
  for x in $( seq 1 ${numDice} ); do
    case "$(roll_dice ${numSides})" in
      1) _BLANK=$((_BLANK+1));;
      2) _SUCCESS=$((_SUCCESS-1));;
      3) _SUCCESS=$((_SUCCESS-1));;
      4) _SUCCESS=$((_SUCCESS-2));;
      5) _SUCCESS=$((_SUCCESS-2));;
      6) _ADVANTAGE=$((_ADVANTAGE-1));;
      7) _ADVANTAGE=$((_ADVANTAGE-1));;
      8) _SUCCESS=$((_SUCCESS-1))
         _ADVANTAGE=$((_ADVANTAGE-1));;
      9) _SUCCESS=$((_SUCCESS-1))
         _ADVANTAGE=$((_ADVANTAGE-1));;
      10) _ADVANTAGE=$((_ADVANTAGE-2));;
      11) _ADVANTAGE=$((_ADVANTAGE-2));;
      12) _SUCCESS=$((_SUCCESS-1))
          _DESPAIR=$((_DESPAIR+1));;
      *) error "Apparently math is broken."
         exit 1;;
    esac
  done
}

function roll_force() {
  local numDice=${1}
  local numSides=12
  debug "Rolling ${numDice} ${FUNCNAME#roll_} dice:"
  for x in $( seq 1 ${numDice} ); do
    case "$(roll_dice ${numSides})" in
      1-6)   _DARKSIDE=$((_DARKSIDE+1));;
      7)     _DARKSIDE=$((_DARKSIDE+2));;
      8-9)   _LIGHTSIDE=$((_LIGHTSIDE+1));;
      10-12) _LIGHTSIDE=$((_LIGHTSIDE+2));;
      *) error "Apparently math is broken."
         exit 1;;
    esac
  done
}


# Handle command line arguments
invalidUsage=false
while getopts ":vVmMhH" arg; do
  case ${arg} in
    h|H) usage
         exit 0;;
    m|M) print_map;;
    v|V) _VERBOSE=$((_VERBOSE+1));;
    :) output "ERROR: Option -${OPTARG} requires an argument."
       invalidUsage=true;;
    *) output "ERROR: Invalid option: -${OPTARG}"
       invalidUsage=true;;
  esac
done #End arguments
# Shift flags out of arguments, leaving only valid dice notation in $@
# Ref: https://en.m.wikipedia.org/wiki/Dice_notation
shift $((${OPTIND} - 1))

# Check for invalid usage
if ${invalidUsage}; then
  usage && exit 1
fi

debug "Args: ${@}"

# Main 
# Convert arguments for parsing. Order shouldn't matter
for arg in ${@}; do
  if ! grep -qPi '^\d*[bsadpcf]$' <<<"${arg}"; then
    error "Encountered unknown argument in equation: ${arg}"
    usage
    exit 2
  fi
  debug "Rolling dice for argument \"${arg}\""
  NUMDICE=$( grep -oP '\d+' <<<"${arg}" )
  DIETYPE=$( grep -oPi '[bsadpcf]' <<<"${arg}" )
  case "${DIETYPE}" in
    b) roll_boost       "${NUMDICE:-1}";;
    s) roll_setback     "${NUMDICE:-1}";;
    a) roll_ability     "${NUMDICE:-1}";;
    d) roll_difficulty  "${NUMDICE:-1}";;
    p) roll_proficiency "${NUMDICE:-1}";;
    c) roll_challenge   "${NUMDICE:-1}";;
    f) roll_force       "${NUMDICE:-1}";;
    *) error "That's not true!  That's impossible!"
       exit 3;;
  esac
done

# Check for verbosity flags and format accordingly
if [[ ${_VERBOSE} -gt 1 ]]; then
  echo
  if [[ ${_VERBOSE} -gt 2 ]]; then
    print_verbose
    echo
  fi
fi

# Print final results
print_results

