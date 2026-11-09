NVIM ?= nvim
STYLUA ?= stylua
SELENE ?= selene

.PHONY: check format format-check lint smoke

check: format-check lint smoke

format:
	$(STYLUA) .

format-check:
	$(STYLUA) --check .

lint:
	$(SELENE) .

smoke:
	$(NVIM) --headless -i NONE -u init.lua '+qa!'
