build/%: %.fut
	@mkdir -p $(@D)
	futhark c $< -o $@

.PHONY: all
all: build/04a.dimensions
	time ./$< < data/pizza_3_vars_fix.txt
