# Verilog Projects

A collection of digital design projects implemented in Verilog/SystemVerilog, focused on learning and applying hardware design concepts such as:

- Finite State Machines (FSM)
- FSMD architectures
- UART communication protocols
- Verification and testbench development
- Modular RTL design

---

# Projects

## Fibonacci FSMD

Implementation of a Fibonacci calculator using a **Finite State Machine with Datapath (FSMD)** architecture.

### Features
- FSM with three states: `idle`, `op`, `done`
- Iterative Fibonacci computation
- Clear separation between control path and datapath
- RTL simulation and verification

### Key Concepts
- FSMD design methodology
- Sequential arithmetic operations
- Register-transfer level (RTL) design
- State machine controlled datapath

📁 Folder: `fibonacci_fsmd`

---

## UART (Universal Asynchronous Receiver Transmitter)

Full UART implementation in Verilog using a modular FSMD-based architecture.

### Features
- Configurable baud rate generator
- UART transmitter and receiver modules
- 16x oversampling receiver
- TX/RX synchronization logic
- Loopback verification testbench

### Key Concepts
- Serial communication
- Parallel-to-serial conversion
- Serial-to-parallel conversion
- Tick-based synchronization
- Pulse generation and edge detection

📁 Folder: `UART`

---

## UART Memory System with MPU Protection

Complete UART-controlled memory system implemented using a centralized FSMD controller architecture.

The system allows an external device to execute protected READ and WRITE transactions over UART communication while enforcing memory access validation through an MPU (Memory Protection Unit).

### Features
- UART-controlled RAM access
- Centralized FSMD controller
- MPU-based memory protection
- READ and WRITE transaction support
- Error handling for invalid commands and invalid accesses
- Modular RTL architecture
- Self-checking verification environment
- Randomized and directed testbench validation

### Architecture
The system is composed of:
- UART Core
- Controller FSM
- RAM Memory
- MPU (Memory Protection Unit)

### Supported Operations

#### WRITE Transaction
```text
[CMD] [ADDR] [DATA]
