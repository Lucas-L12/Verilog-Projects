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
