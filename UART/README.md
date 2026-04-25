# UART in Verilog

## 🧠 Architecture

![UART Diagram](docs/Uart_chart.jpg)

---

## 🔗 Blocks Description
- [Interface ](docs/interface.md)

### RX Path
- [Baud Rate Generator](docs/baudrate.md)
- [Receiver](docs/receiver.md)


### TX Path

- [Transmitter](docs/transmitter.md)

---

## 🔁 Data Flow

RX:
rx → receiver → interface → r_data

TX:
w_data → interface → transmitter → tx
