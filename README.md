# go-board-fpga

Verilog designs for the Nandland Go Board (Lattice iCE40-HX1K, VQ100, 25 MHz),
built with the open-source toolchain instead of Lattice iCEcube2.

Toolchain: Yosys (synthesis), nextpnr-ice40 (place and route), IceStorm for
`icepack`, `icetime`, and `iceprog`. Everything runs from a single Makefile on
macOS.

## Build

From the repo root:

    make          # synthesize, place and route, pack the bitstream
    make prog     # flash the board over USB
    make timing   # icetime timing report
    make clean    # remove generated files

`PROJ` picks the project and defaults to `project-1`:

    make PROJ=project-1 prog

Each project directory holds its sources and a `project.mk` naming the top
module. Pin constraints are shared across projects in
[constraints/Go_Board_Constraints.pcf](constraints/Go_Board_Constraints.pcf).

Generated files (`.json`, `.asc`, `.bin`, `.rpt`) land next to the sources and
are gitignored.

## Projects

| # | Project | What it covers | Status |
|---|---------|----------------|--------|
| 01 | [Switches to LEDs](project-1/) | Combinational assignment, pin constraints, full build flow | Done |
| 02 | LUT | Boolean logic, look-up tables | Planned |
| 03 | Flip-Flop | Registers, clocked logic | Planned |
| 04 | Debounce | Counter-based switch debouncing | Planned |
| 05 | Seven Segment | BCD to seven-segment decode, display multiplexing | Planned |
| 06 | Simulation | Testbench structure, waveform inspection | Planned |
| 07 | UART RX | Oversampled serial receive, start-bit detection | Planned |
| 08 | UART TX | Serial transmit state machine | Planned |
| 09 | VGA | Sync generation, test patterns | Planned |
| 10 | Pong | Full design: VGA output, game state machine, score display | Planned |

Simulation targets (Icarus Verilog and GTKWave) get added at project 06, where
the tutorial series introduces testbenches.

## Scope

These designs follow the [Nandland Go Board tutorial series](https://nandland.com/project-1-your-first-go-board-project/)
and Russell Merrick's *Getting Started with FPGAs*. The RTL is written by me;
the projects and their specifications come from that series. The build system
and the port to the open-source toolchain are my own.

The pin constraints file is provided by Nandland for the Go Board.

## License

MIT. See [LICENSE](LICENSE).
