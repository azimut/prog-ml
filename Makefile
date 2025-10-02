SRCS = $(wildcard src/0*.fut)

.PHONY: literate
literate: $(patsubst %.fut,%.md,$(notdir $(SRCS)))

media/%.png: media/%.gp
	GNUTERM='pngcairo size 800,600' gnuplot $< > $@

%.md: src/%.fut utils.fut
	cp $< .
	futhark literate -v --stop-on-error $(<F)
	rm -f $*.fut $*.c $*
	sed -i '/^!/s|(|(media/|' $@
	mkdir -p media/
	rm -rf ./media/$(*)-img
	-mv $(*)-img/ media/

build/%: src/%.fut
	@mkdir -p $(@D)
	futhark c $< -o $@

utils.fut: src/utils.fut; ln -s $< $@

.PHONY: clean
clean:; rm -vrf ./*.fut ./*.c ./*.actual ./*.expected ./build/*
