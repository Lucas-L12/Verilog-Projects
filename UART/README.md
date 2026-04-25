# UART in Verilog

This project implements a UART (Universal Asynchronous Receiver Transmitter) in Verilog.

---

## 🧠 Architecture

| Block | Description |
|------|------------|
| [Baud Rate Generator](docs/baudrate.md) | Generates sampling tick |
| [Receiver](docs/receiver.md) | Receives serial data |
| [Transmitter](docs/transmitter.md) | Sends serial data |
| [Interface](docs/interface.md) | Control logic |
| [Core](docs/core.md) | Top-level integration |

---

## 🔁 Data Flow

TX Path:
wr_uart → Interface → Transmitter → tx

RX Path:
rx → Receiver → Interface → rd_uart

---

## 🧪 Testbench

Loopback test: TX → RX

---

## 📌 Features

- 8-bit data
- 1 stop bit
- Oversampling (16x)
- Configurable baud rate
