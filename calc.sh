#!/bin/bash

# Check for existence of history.txt
if [ ! -f history.txt ]; then
    echo "history.txt not found. Creating it now."
    touch history.txt
fi

# Sample calculation logic (for demonstration)
operand1=$1
operator=$2
operand2=$3
result=0

case "$operator" in
  +)
    result=$((operand1 + operand2))
    ;;
  -)
    result=$((operand1 - operand2))
    ;;
  x)
    result=$((operand1 * operand2))
    ;;
  /)
    result=$((operand1 / operand2))
    ;;
  *)
    echo "Invalid operator"
    exit 1
    ;;
esac

echo "$(date '+%Y-%m-%d %H:%M:%S') $operand1 $operator $operand2 = $result" >> history.txt