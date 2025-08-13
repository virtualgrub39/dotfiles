STOWDIR := $(CURDIR)
TARGET  := $(HOME)

stow:
	stow --dir=$(STOWDIR) --target=$(TARGET) --verbose .

dry:
	stow -n --dir=$(STOWDIR) --target=$(TARGET) --verbose .

restow:
	stow --restow --dir=$(STOWDIR) --target=$(TARGET) --verbose .

unstow:
	stow --delete --dir=$(STOWDIR) --target=$(TARGET) --verbose .
