#!/bin/bash

OP1=""
OPERATOR=""
OP2=""

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <operand1> <operator> <operand2>"
    exit 1
fi

OP1=$1
OPERATOR=$2
OP2=$3

if ! [[ "$OP1" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || ! [[ "$OP2" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    echo "Error: Operands must be numbers."
    exit 1
fi

case "$OPERATOR" in
    "+"|"-"|"*"|"/")
        ;;
    *)
        echo "Error: Invalid operator. Use +, -, *, or /."
        exit 1
        ;;
esac

echo "Operand 1: $OP1"
echo "Operator: $OPERATOR"
echo "Operand 2: $OP2"