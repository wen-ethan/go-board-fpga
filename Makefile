PROJ ?= project-1

include $(PROJ)/project.mk

PCF     = constraints/Go_Board_Constraints.pcf
DEVICE  = --hx1k --package vq100
# SRC is per-project, COMMON is shared modules from common/
SOURCES = $(addprefix $(PROJ)/,$(SRC)) $(addprefix common/,$(COMMON))
# TB is per-project; simulation builds the testbench alongside the design
SIM_SRC = $(addprefix $(PROJ)/,$(TB) $(SRC)) $(addprefix common/,$(COMMON))
OUT     = $(PROJ)/$(TOP)

all: $(OUT).bin

$(OUT).json: $(SOURCES)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(SOURCES)

$(OUT).asc: $(OUT).json $(PCF)
	nextpnr-ice40 $(DEVICE) --json $(OUT).json --pcf $(PCF) --asc $@

$(OUT).bin: $(OUT).asc
	icepack $< $@

prog: $(OUT).bin
	iceprog $<

timing: $(OUT).asc
	icetime -d hx1k -mtr $(OUT).rpt $<

$(PROJ)/sim.vvp: $(SIM_SRC)
	iverilog -g2012 -o $@ $(SIM_SRC)

sim: $(PROJ)/sim.vvp
	cd $(PROJ) && vvp sim.vvp

wave: sim
	gtkwave $(PROJ)/dump.vcd

clean:
	rm -f $(PROJ)/*.json $(PROJ)/*.asc $(PROJ)/*.bin $(PROJ)/*.rpt
	rm -f $(PROJ)/*.vvp $(PROJ)/*.vcd

.PHONY: all prog timing sim wave clean