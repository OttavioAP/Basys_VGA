# Basys 3 Verilog Hello World (CLI + VS Code Workflow) 

This repository is a minimal “hello world” FPGA project for the **Digilent Basys 3 AMD Artix 7 FPGA Trainer Board** board.

The goal is to demonstrate a **clean, professional FPGA workflow** using:
- VS Code for editing
- Git for version control
- Icarus Verilog for simulation
- GTKWave for waveform viewing
- Vivado (CLI / batch mode) for synthesis and programming

The design simply blinks one LED.

---

## 1. System Requirements

- Ubuntu 20.04+ (tested on 22.04)
- Basys 3 FPGA board
- USB cable (for programming the board)

---

## 2. Install Simulation Tools

### Install packages
```bash
sudo apt update
sudo apt install -y \
    git \
    make \
    iverilog \
    gtkwave
```

## 3. Install Vivado (for synthesis + programming)

Install AMD/Xilinx Vivado (WebPACK is sufficient for the Basys 3). Make sure `vivado` is on your PATH.

## 4. Simulate

```bash
make sim
```

This runs the testbench, generates `blink.vcd`, and exits. Open the waveform with:

```bash
gtkwave sim/build/blink.vcd
```

## 5. Build Bitstream (CLI)

```bash
make bitstream
```

Output: `build/blink.bit`

## 6. Program Board (CLI)

Plug in the Basys 3 over USB, then:

```bash
make program
```

## 7. What to Expect

The LED on **LD0** should toggle about every 0.5 seconds (1 Hz blink).

## 8. Troubleshooting

- `make sim` says “up to date”: ensure the target is phony or force with `make -B sim`. If a file/dir named `sim` exists, it can mask the target.
- Vivado not found: add to PATH (example) `export PATH="/opt/2025.1/Vivado/bin:$PATH"` or pass `make bitstream VIVADO=/opt/2025.1/Vivado/bin/vivado`.
- `make program` can’t find hardware targets: install cable drivers/udev rules via Vivado’s `install_drivers` script, then unplug/replug the board.
- Permissions: ensure your user is in `dialout` (and `plugdev`) and log out/in after adding groups.
- Generated artifacts: Vivado creates `.Xil/`, `clockInfo.txt`, `vivado*.log`, `vivado*.jou` — these should be gitignored.
