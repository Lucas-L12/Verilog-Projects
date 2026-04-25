# Core

## Description
Top-level module that connects all blocks.

## Components
- Baud generator
- Receiver
- Transmitter
- Interface

## Data Flow

TX:
w_data → interface → transmitter → tx

RX:
rx → receiver → interface → r_data
### Note
A rising-edge detector is implemented to convert the level-based `tx_start` signal into a single-cycle pulse (`tx_start_pulse`). This ensures that the transmitter is triggered only once per data word.
