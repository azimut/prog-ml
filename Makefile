build/%: %.fut
	@mkdir -p $(@D)
	futhark c $< -o $@

.PHONY: all
all: build/05.sigmoid
	time ./$< < data/police_fix.txt
