BUILD_DIR := build
KERNEL := $(BUILD_DIR)/kernel.elf
OBJECTS := $(BUILD_DIR)/boot.o

NASM ?= nasm
NASMFLAGS := -f elf32 -F dwarf -g
LD := ld
LDFLAGS := -m elf_i386 -T src/linker.ld

NASM_PRESENT := $(shell if command -v $(NASM) >/dev/null 2>&1; then echo yes; fi)

ifeq ($(NASM_PRESENT),)
$(error Error: NASM assembler ($(NASM)) not found in PATH. Install NASM (e.g. sudo apt install nasm, brew install nasm, or pacman -S nasm on MSYS2) and retry.)
endif

.PHONY: all kernel iso clean

all: kernel

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/boot.o: src/boot.asm | $(BUILD_DIR)
	$(NASM) $(NASMFLAGS) $< -o $@

$(KERNEL): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

kernel: $(KERNEL)

iso: kernel
	scripts/build_iso.sh

clean:
	rm -rf $(BUILD_DIR)
