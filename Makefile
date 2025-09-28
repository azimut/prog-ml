build/%: %.fut
	@mkdir -p $(@D)
	futhark c $< -o $@

.PHONY: all
all: build/04b.dimensions_bias
	time ./$< < data/pizza_3_vars_fix.txt
