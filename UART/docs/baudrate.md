# Baud Rate Generator

## Description
The baud rate generator produces a periodic tick signal used as an enable signal for the UART modules instead of using the system clock directly.

In this design,the UART receiver and transmitter use an internal counter (16 ticks per bit) to achieve the desired baud rate through oversampling.

## How it works
The generator is implemented as a counter that divides the system clock frequency by a parameter `M`. A tick (`max_tick`) is generated once every `M` clock cycles.

## Baud Rate Calculation
Since each bit is sampled using 16 ticks, the effective baud rate is: baud_rate ≈ f_clk / (M × 16).
For a 50 MHz clock and a target baud rate of 115200: M ≈ 50,000,000 / (115200 × 16) ≈ 27
