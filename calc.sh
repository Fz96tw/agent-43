#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <operand1> <operator> <operand2>"
    exit 1
fi

operand1=$1
operator=$2
operand2=$3

case "$operator" in
    +) result=$(echo "$operand1 + $operand2" | bc);;
    -) result=$(echo "$operand1 - $operand2" | bc);;
    \*) result=$(echo "$operand1 * $operand2" | bc);;
    /)
        if [ "$operand2" -eq 0 ]; then
            echo "Error: Division by zero."
            exit 1
        fi
        result=$(echo "scale=2; $operand1 / $operand2" | bc);;
    *)
        echo "Error: Invalid operator. Use +, -, *, or /."
        exit 1;;
esac

echo "$operand1 $operator $operand2 = $result"

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "$timestamp $operand1 $operator $operand2 = $result" >> history.txt