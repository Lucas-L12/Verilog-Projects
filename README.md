#  Verilog Projects

A collection of digital design projects implemented in Verilog, focused on learning and applying hardware design concepts such as FSM, FSMD, and communication protocols.

---

##  Projects

###  Fibonacci FSMD
Implementation of a Fibonacci calculator using a **Finite State Machine with Datapath (FSMD)** architecture.

**Features:**
- FSM with three states: `idle`, `op`, `done`
- Iterative computation
- Clear separation between control and datapath

📁 Folder: `fibonacci_fsmd`

---

###  UART (Universal Asynchronous Receiver Transmitter)
Full UART implementation in Verilog using modular design and FSM-based architecture.

**Features:**
- Configurable baud rate generator
- Receiver and transmitter using FSMD
- 16x oversampling for reliable data sampling
- TX and RX interfaces with control flags
- Loopback testbench for verification

**Key Concepts:**
- Edge detection (pulse generation)
- Synchronization using tick signals
- Serial-to-parallel and parallel-to-serial conversion

📁 Folder: `UART`

---

