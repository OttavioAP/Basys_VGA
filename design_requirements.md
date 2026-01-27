# MT9V034 → FPGA → VGA Processing Pipeline

## 1. Project Overview

**Goal:**
Interface an MT9V034 CMOS image sensor to a Digilent Basys 3 FPGA board, perform real‑time signal processing on the video stream, and output the processed image either to a VGA monitor or indirectly to a Linux PC for human viewing.

This project is intended as a **real-time FPGA vision pipeline**, emphasizing streaming architectures, precise timing control, and hardware-first design.

---

## 2. Hardware Constraints & Assumptions

### 2.1 FPGA Platform

* **Board:** Digilent Basys 3
* **FPGA:** Xilinx Artix‑7 (XC7A35T)
* **Available Resources:**

  * ~33k LUTs
  * ~1.8 Mb BRAM
  * No external SDRAM

### 2.2 I/O Availability

* **PMODs:**

  * 4 ports × 8 signal pins each
  * 3.3 V logic levels
* **VGA Output:**

  * 640×480 @ 60 Hz
  * 12‑bit RGB (4:4:4)
* **USB:**

  * Programming, UART only (not usable for camera input)

### 2.3 Camera Sensor (MT9V034)

* **Interface:**

  * 8‑bit parallel pixel bus
  * PCLK (~10–27 MHz)
  * HSYNC, VSYNC
  * I²C for configuration
* **Pixel Format:** Grayscale
* **Voltage Compatibility:** 3.3 V IO compatible

---

## 3. System Architecture

### 3.1 High‑Level Dataflow

```
MT9V034
   ↓
Pixel Capture (PCLK domain)
   ↓
Line Buffers (BRAM)
   ↓
Streaming Processing Pipeline
   ↓
VGA Scanout (25 MHz pixel clock)
```

Key architectural principle: **streaming, not frame-buffered** processing.

---

## 4. Functional Requirements

### 4.1 Camera Configuration Subsystem

* Implement I²C master controller
* Configure MT9V034 registers at startup
* Support:

  * Resolution selection
  * Frame rate configuration
  * Gain / exposure setup

### 4.2 Pixel Capture Subsystem

* Sample pixel data on PCLK edge
* Correctly gate pixels using HSYNC / VSYNC
* Generate:

  * Pixel valid signal
  * Line valid signal
  * Frame valid signal

### 4.3 Clock Domain Handling

* Camera PCLK ≠ VGA pixel clock
* Implement safe clock domain crossings
* Use line buffers or FIFOs as boundaries

### 4.4 Signal Processing Pipeline

Initial target algorithms (must be streaming-compatible):

* Thresholding
* Edge detection (Sobel / Prewitt)
* Simple blob / centroid detection

Design constraints:

* No full-frame random access
* Fixed-latency pipelines
* Deterministic throughput (1 pixel per clock)

### 4.5 VGA Output Subsystem

* Generate VGA timing (HSYNC, VSYNC, blanking)
* Map grayscale or processed data to RGB
* Optionally overlay debug graphics

---

## 5. Non‑Functional Requirements

* **Real-time operation:** No dropped frames at target resolution
* **Deterministic latency:** Fully synchronous pipelines
* **Resource efficiency:** Must fit within on-chip BRAM
* **Debuggability:** Test pattern generation and UART debug hooks

---

## 6. Development Phases & Timeline

### Phase 0 — Environment Setup (Week 0)

* Toolchain setup (Vivado)
* Basys 3 programming & UART sanity checks

---

### Phase 1 — VGA Bring-Up (Week 1)

* Implement VGA timing generator
* Display color bars / test patterns
* Validate stable output on monitor

**Milestone:** Verified VGA output with synthetic data

---

### Phase 2 — Camera Interface Bring-Up (Week 2)

* Implement I²C controller
* Configure MT9V034
* Capture raw pixel stream
* Dump small pixel samples via UART

**Milestone:** Verified raw camera data capture

---

### Phase 3 — Raw Video Display (Week 3)

* Insert line buffers
* Bridge camera domain to VGA domain
* Display raw grayscale image

**Milestone:** Live camera image on VGA

---

### Phase 4 — Signal Processing Integration (Weeks 4–5)

* Insert processing pipeline between capture and display
* Validate pixel-accurate results
* Tune pipeline depth and timing

**Milestone:** Processed video displayed in real time

---

### Phase 5 — Optimization & Cleanup (Week 6)

* Resolution scaling
* Timing closure
* Resource usage optimization
* Documentation & block diagrams

**Milestone:** Stable, documented end‑to‑end system

---

## 7. Risks & Mitigations

| Risk              | Mitigation                              |
| ----------------- | --------------------------------------- |
| BRAM exhaustion   | Downscale resolution, reduce buffering  |
| Timing violations | Pipeline aggressively, constrain clocks |
| CDC bugs          | Explicit CDC modules, simulation        |
| Debug difficulty  | Early test patterns and UART hooks      |

---

## 8. Deliverables

* Synthesizable Verilog/SystemVerilog source
* Timing constraints (.xdc)
* Block diagram & pipeline documentation
* Demo showing live processed video

---

## 9. Success Criteria

The project is considered successful if:

* MT9V034 streams video into FPGA reliably
* At least one real-time processing algorithm runs continuously
* Output is viewable on a VGA monitor without dropped frames
* System meets timing and resource constraints on Basys 3

---

*This design intentionally avoids external memory and USB video transport, focusing on core FPGA vision fundamentals.*
