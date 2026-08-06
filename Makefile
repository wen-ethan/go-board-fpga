PROJ ?= project-1

include $(PROJ)/project.mk

PCF     = constraints/Go_Board_Constraints.pcf
DEVICE  = --hx1k --package vq100
SOURCES = $(addprefix $(PROJ)/,$(SRC))
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

clean:
	rm -f $(PROJ)/*.json $(PROJ)/*.asc $(PROJ)/*.bin $(PROJ)/*.rpt

.PHONY: all prog timing clean