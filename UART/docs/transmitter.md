# Transmitter

## Description
UART transmitter implemented using FSM.

## States
- Idle
- Start
- Data
- Stop

## Inputs
- `tx_start`
- `s_tick`
- `din`

## Outputs
- `tx`
- `tx_done_tick`

## Important detail ⚠️
`tx_start` must be a pulse (1 clock cycle), not a level.
