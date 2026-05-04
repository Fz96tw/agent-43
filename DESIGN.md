# AGENT-43 — Technical Design

# Technical Design for Calc Utility

## Architecture
- **Type**: Command-line utility implemented in Bash
- **Components**:
  - Bash Script (`calc.sh`): Handles inputs, performs calculations, and manages history logging.
  - History File (`history.txt`): Stores input arguments and results of each calculation.

## Components
- **Bash Script (`calc.sh`)**:
  - Parses command-line arguments for operands and operator.
  - Performs calculation based on operator.
  - Appends inputs and results to `history.txt`.
- **History File (`history.txt`)**:
  - Logs each computation performed by the script.
  - Format: `<timestamp> <operand1> <operator> <operand2> = <result>`

## Data Flow
1. User runs the `calc.sh` script with appropriate command-line arguments (e.g., `./calc.sh 3 + 5`).
2. Script parses arguments to identify operands and operator.
3. Script performs calculation based on parsed operator.
4. Result and inputs are appended to `history.txt`.

## Key Decisions
- Use of Bash ensures compatibility with Unix-like systems without additional dependencies.
- History logging format is simple text to facilitate easy review or parsing.

## Primary Output Files
- `calc.sh`: The main script file.
- `history.txt`: Text file recording all calculations.