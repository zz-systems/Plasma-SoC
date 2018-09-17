TARGETS = socfpga_cyclone5_de1_soc

all: $(TARGETS)

#$(TARGETS): %.dtb %.dts
#	$(call compile, $@, $<)

socfpga_cyclone5_de1_soc: #socfpga_cyclone5_de1_soc.dtb
	$(call compile, $@, $<)

.PHONY: clean
clean:
	rm *.dtp
	rm *.tmp.dts

define compile
	cpp -Iinclude -E -P -x assembler-with-cpp $(1).dts | perl -p0e 's/(?!^)\/dts-v1\/;//g' > $(1).tmp.dts
	dtc -O dtb -b 0 -o $(1).dtb $(1).tmp.dts
	rm $(1).tmp.dts
endef