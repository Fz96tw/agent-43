#!/bin/bash

# Simple calculator script

# Function to log history
log_history() {
  echo "$(date): $1 $2 $3 = $4" >> history.txt
}

# Main calculation logic
if [[ $# -ne 3 ]]; then
  echo "Usage: ./calc.sh <num1> <operator> <num2>"
  exit 1
fi

num1=$1
operator=$2
num2=$3

case $operator in
  +)
    result=$((num1 + num2))
    ;;
  -)
    result=$((num1 - num2))
    ;;
  \\*)
    result=$((num1 * num2))
    ;;
  /)
    result=$((num1 / num2))
    ;;
  *)
    echo "Unknown operator: $operator"
    exit 1
    ;;
esac

# Log the calculation
log_history "$num1" "$operator" "$num2" "$result"

# Output result
echo "Result: $result"