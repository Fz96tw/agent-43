#!/bin/bash

# Function to log history of calculations
log_history() {
    local operand1=$1
    local operator=$2
    local operand2=$3
    local result=$4
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp $operand1 $operator $operand2 = $result" >> history.txt
}

# Sample calculation code (for demonstration)
# Replace with actual calculation logic as needed
read -p "Enter first operand: " operand1
read -p "Enter operator (+, -, *, /): " operator
read -p "Enter second operand: " operand2

# Perform calculation
case $operator in
    +)
        result=$(echo "$operand1 + $operand2" | bc)
    ;;
    -)
        result=$(echo "$operand1 - $operand2" | bc)
    ;;
    *)
        echo "Invalid operator"
        exit 1
    ;;
 esac

# Log the calculation
log_history $operand1 $operator $operand2 $result

# Output the result
echo "Result: $result"