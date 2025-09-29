.PHONY: all
all: build/04a.dimensions
	time ./$< < data/pizza_3_vars_fix.txt

%.md: src/%.fut
	cp $< .
	futhark literate -v --stop-on-error $(<F)
	rm -f $*.fut $*.c $*
	sed -i '/^!/s|(|(media/|' $@
	mkdir -p media/
	rm -rf ./media/$(*)-img
	mv $(*)-img/ media/

build/%: src/%.fut
	@mkdir -p $(@D)
	futhark c $< -o $@

.PHONY: clean
clean:; rm -vrf ./*.fut ./*.c ./*.actual ./*.expected ./build/*
