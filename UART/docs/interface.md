# Interface

## Description
The interface module acts as a simple buffer with a status flag. It stores a data word and indicates whether the data is valid or has been consumed.

## Operation

- When `set_flag` is asserted, the input data (`din`) is stored and the flag is set.
- When `clr_flag` is asserted, the flag is cleared, indicating that the data has been consumed.
- The stored data remains unchanged until new data is written.

## Behavior

- `flag = 1` → data is valid (buffer full)
- `flag = 0` → no valid data (buffer empty)

## Note

The flag is level-based, not a pulse. Therefore, additional logic may be required when connecting to modules that expect pulse signals (e.g., transmitter start signal).
