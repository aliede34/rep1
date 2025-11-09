BUILD_DIR := build
KERNEL := $(BUILD_DIR)/kernel.elf
OBJECTS := $(BUILD_DIR)/boot.o

NASM := nasm
NASMFLAGS := -f elf32 -F dwarf -g
LD := ld
LDFLAGS := -m elf_i386 -T src/linker.ld

.PHONY: all kernel iso clean

all: kernel

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/boot.o: src/boot.asm | $(BUILD_DIR)
	@command -v $(NASM) >/dev/null 2>&1 || { \
	        echo "Error: NASM assembler ($(NASM)) not found in PATH." >&2; \
	        echo "Install NASM (e.g. sudo apt install nasm) and retry." >&2; \
	        exit 127; \
	}
	$(NASM) $(NASMFLAGS) $< -o $@

$(KERNEL): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

kernel: $(KERNEL)

iso: kernel
	scripts/build_iso.sh

clean:
	rm -rf $(BUILD_DIR)
