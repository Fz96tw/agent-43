#!/bin/bash

# Simple calculator script

# Function to log history
log_history() {
  echo "$(date): $1 = $2" >> history.txt
}

# Normalize bc output: add leading zero, strip trailing zeros
normalize_result() {
  echo "$1" | sed 's/^\./0./; s/^-\./-0./; s/\(\.[0-9]*[1-9]\)0*$/\1/; s/\.0*$//'
}

# Check for sine function input: sin( <number> ) with flexible whitespace
if [[ $# -ge 1 ]]; then
  # Reconstruct all args into one string to handle whitespace-split invocations
  full_input="$*"

  # Match sin(...) pattern
  if [[ "$full_input" =~ ^[[:space:]]*sin[[:space:]]*\([[:space:]]*([^[:space:]]+)[[:space:]]*\)[[:space:]]*$ ]]; then
    value="${BASH_REMATCH[1]}"

    # Validate: must be a single valid number (integer or decimal, optional leading minus)
    if ! [[ "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
      echo "Invalid input: '$value' is not a valid number"
      exit 1
    fi

    # Compute sine using bc (input is degrees, convert to radians)
    result=$(echo "scale=10; s($value * 4 * a(1) / 180)" | bc -l 2>/dev/null)
    if [[ $? -ne 0 || -z "$result" ]]; then
      echo "Error computing sine"
      exit 1
    fi

    result=$(normalize_result "$result")
    log_history "sin($value)" "$result"
    echo "Result: $result"
    exit 0
  fi

  # If input looks like it starts with sin but didn't match, it's malformed
  if [[ "$full_input" =~ ^[[:space:]]*sin[[:space:]]*\( ]]; then
    echo "Invalid input: expected sin(<number>)"
    exit 1
  fi
fi

# Main calculation logic
if [[ $# -ne 3 ]]; then
  echo "Usage: ./calc.sh <num1> <operator> <num2>"
  echo "       ./calc.sh \"sin(<num>)\""
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
