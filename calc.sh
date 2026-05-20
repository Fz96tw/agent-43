#!/bin/bash

# Simple calculator script

# Function to log history
log_history() {
  echo "$(date): $1 = $2" >> history.txt
}

# Strip trailing zeros from bc output (e.g. 4.0000000000 -> 4, 3.8000000000 -> 3.8)
normalize_result() {
  echo "$1" | sed 's/\(\.[0-9]*[1-9]\)0\+$/\1/;s/\.0*$//'
}

# History view command: --history [N]
if [[ "$1" == "--history" ]]; then
  if [[ $# -gt 2 ]]; then
    echo "Error: --history cannot be combined with calculation arguments"
    exit 1
  fi
  if [[ ! -f history.txt || ! -s history.txt ]]; then
    echo "No history yet."
    exit 0
  fi
  if [[ -n "$2" ]]; then
    if ! [[ "$2" =~ ^[0-9]+$ ]]; then
      echo "Error: --history N requires a positive integer"
      exit 1
    fi
    tail -n "$2" history.txt
  else
    cat history.txt
  fi
  exit 0
fi

# History clear command: --clear-history
if [[ "$1" == "--clear-history" ]]; then
  if [[ $# -gt 1 ]]; then
    echo "Error: --clear-history cannot be combined with other arguments"
    exit 1
  fi
  > history.txt
  echo "History cleared."
  exit 0
fi

# sqrt function: ./calc.sh "sqrt(x)"
_sqrt_re='^[[:space:]]*sqrt[[:space:]]*\([[:space:]]*([^)]*)\)[[:space:]]*$'
if [[ $# -eq 1 && "$1" =~ $_sqrt_re ]]; then
  inner="${BASH_REMATCH[1]}"
  inner="${inner#"${inner%%[![:space:]]*}"}"
  inner="${inner%"${inner##*[![:space:]]}"}"
  if [[ "$inner" =~ [[:space:]] ]]; then
    echo "Error: sqrt requires exactly one numeric argument"
    exit 1
  fi
  if [[ "$inner" =~ ^- ]]; then
    echo "Error: sqrt of negative number is undefined"
    exit 1
  fi
  if ! [[ "$inner" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: invalid input for sqrt: '$inner'"
    exit 1
  fi
  result=$(echo "scale=10; sqrt($inner)" | bc -l)
  result=$(normalize_result "$result")
  log_history "sqrt($inner)" "$result"
  echo "Result: $result"
  exit 0
fi

# Main calculation logic
if [[ $# -ne 3 ]]; then
  echo "Usage: ./calc.sh <num1> <operator> <num2>"
  echo "       ./calc.sh \"sqrt(x)\""
  echo "       ./calc.sh --history [N]"
  echo "       ./calc.sh --clear-history"
  exit 1
fi

num1=$1
operator=$2
num2=$3

# Validate both operands are numbers (integer or decimal, optional leading minus)
if ! [[ "$num1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Invalid input: '$num1' is not a valid number"
  exit 1
fi
if ! [[ "$num2" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Invalid input: '$num2' is not a valid number"
  exit 1
fi

case $operator in
  +)
    result=$(echo "scale=10; $num1 + $num2" | bc -l)
    ;;
  -)
    result=$(echo "scale=10; $num1 - $num2" | bc -l)
    ;;
  \*)
    result=$(echo "scale=10; $num1 * $num2" | bc -l)
    ;;
  /)
    if [[ "$num2" == "0" || "$num2" == "0.0" || "$num2" =~ ^-?0\.0+$ ]]; then
      echo "Error: division by zero"
      exit 1
    fi
    result=$(echo "scale=10; $num1 / $num2" | bc -l)
    ;;
  *)
    echo "Unknown operator: $operator"
    exit 1
    ;;
esac

result=$(normalize_result "$result")

# Log the calculation
log_history "$num1 $operator $num2" "$result"

# Output result
echo "Result: $result"
