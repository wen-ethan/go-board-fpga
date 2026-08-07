# go-board-fpga

Verilog designs for the Nandland Go Board (Lattice iCE40-HX1K, VQ100, 25 MHz),
built with the open-source toolchain instead of Lattice iCEcube2.

Toolchain: Yosys (synthesis), nextpnr-ice40 (place and route), IceStorm for
`icepack`, `icetime`, and `iceprog`, plus Icarus Verilog and GTKWave for
simulation. Everything runs from a single Makefile on macOS.

## Build

From the repo root, where `PROJ` picks the project:

    make PROJ=project-x           # synthesize, place and route, pack the bitstream
    make PROJ=project-x prog      # flash the board over USB
    make PROJ=project-x timing    # icetime timing report
    make PROJ=project-x sim       # run the testbench under Icarus Verilog
    make PROJ=project-x wave      # run the testbench, then open the waves in GTKWave
    make PROJ=project-x clean     # remove generated files

`PROJ` defaults to `project-1` when left off.

Each project directory holds its sources and a `project.mk` naming the top
module in `TOP` and its own files in `SRC`. Reusable modules live in
[common/](common/) and are pulled in per project by listing them in `COMMON`.
Pin constraints are shared across projects in
[constraints/Go_Board_Constraints.pcf](constraints/Go_Board_Constraints.pcf).

Every module a design instantiates has to be named in `SRC` or `COMMON` —
yosys only sees the files the Makefile hands it.

Generated files (`.json`, `.asc`, `.bin`, `.rpt`, `.vvp`, `.vcd`) land next to
the sources and are gitignored.

## Simulate

Projects with a testbench name it in `project.mk` as `TB`:

    make PROJ=project-6 sim     # compile with iverilog, run under vvp
    make PROJ=project-6 wave    # same, then open the VCD in GTKWave

`sim` runs `vvp` from inside the project directory, so the `$dumpfile` path in
the testbench stays relative and `dump.vcd` lands next to the sources. `wave`
depends on `sim`, so it does both in one step.

## Serial

The Go Board's FTDI chip exposes two channels. Channel A is the JTAG/config
port `iceprog` uses; channel B is the UART. On macOS they show up as a
consecutive pair, and the UART is the higher-numbered one:

    ls /dev/cu.usbserial-*
    /dev/cu.usbserial-21400     # channel A, programming
    /dev/cu.usbserial-21401     # channel B, UART

Those digits come from the USB location ID, so they change whenever the board
is plugged into a different port. Glob for the UART rather than hardcoding it:

    PORT=$(ls /dev/cu.usbserial-*1 | tail -1)

Use the `cu.*` node rather than `tty.*` — `tty.*` blocks waiting on carrier
detect. To send a byte at 115200 baud:

    exec 3<>"$PORT"
    stty -f "$PORT" 115200 cs8 -cstopb -parenb raw -echo
    printf '7' >&3
    exec 3>&-

To open an interactive session instead, where a loopback design echoes back
whatever you type:

    screen "$PORT" 115200          # quit with Ctrl-A K, then y

`screen` does not locally echo on a serial port — every character you see came
back from the board. Run it from Terminal.app or iTerm rather than the VS Code
integrated terminal, which swallows `Ctrl-A` and leaves no way to quit.

Holding the descriptor open on fd 3 matters. macOS resets a serial device's
termios settings when the last descriptor on it closes, so `stty` followed by a
separate `printf > /dev/...` silently reverts to 9600 baud between the two
commands and the board receives garbage.

## Projects

| # | Project | What it covers | Status |
|---|---------|----------------|--------|
| 01 | [Switches to LEDs](project-1/) | Combinational assignment, pin constraints, full build flow | Done |
| 02 | [LUT](project-2/) | Boolean logic, look-up tables | Done |
| 03 | [Flip-Flop](project-3/) | Registers, clocked logic | Done |
| 04 | [Debounce](project-4/) | Counter-based switch debouncing | Done |
| 05 | [Seven Segment](project-5/) | Hex to seven-segment decode, debounced switch driving a single digit | Done |
| 06 | [Simulation](project-6/) | Testbench structure, waveform inspection | Done |
| 07 | [UART RX](project-7/) | Oversampled serial receive, start-bit detection, hex display of the received byte | Done |
| 08 | [UART Loopback](project-8/) | Serial transmit state machine, echoing each received byte back while displaying it | Done |
| 09 | VGA | Sync generation, test patterns | Planned |
| 10 | Pong | Full design: VGA output, game state machine, score display | Planned |

Project 06 is a blinker driven by four counters, and is where the tutorial
series introduces testbenches — the `sim` and `wave` targets arrive with it.

## Scope

These designs follow the [Nandland Go Board tutorial series](https://nandland.com/project-1-your-first-go-board-project/)
and Russell Merrick's *Getting Started with FPGAs*. The RTL is written by me;
the projects and their specifications come from that series. The build system
and the port to the open-source toolchain are my own.

The pin constraints file is provided by Nandland for the Go Board.

## License

MIT. See [LICENSE](LICENSE).
