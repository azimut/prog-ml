build/%: %.fut
	@mkdir -p $(@D)
	futhark c $< -o $@

.PHONY: all
all: build/03b.gradient_bias data/pizza_fix.txt
	time ./$< < data/pizza_fix.txt
