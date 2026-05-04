#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <operand1> <operator> <operand2>"
    exit 1
fi

operand1=$1
operator=$2
operand2=$3

case $operator in
    +)
        result=$((operand1 + operand2))
        ;;
    -)
        result=$((operand1 - operand2))
        ;;
    \*)
        result=$((operand1 * operand2))
        ;;
    /)
        if [ $operand2 -eq 0 ]; then
            echo "Error: Division by zero."
            exit 1
        fi
        result=$((operand1 / operand2))
        ;;
    *)
        echo "Invalid operator. Supported operators are: +, -, *, /"
        exit 1
        ;;
esac
echo "$(date '+%Y-%m-%d %H:%M:%S') $operand1 $operator $operand2 = $result" >> history.txt
echo "$operand1 $operator $operand2 = $result"