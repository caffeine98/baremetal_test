CFLAGS ?= -mcpu=cortex-m4 -mthumb -Wall -Wextra -Wshadow -Werror -Wundef -Wfloat-equal

LDFLAGS ?= -T link.ld -nostdlib

LIBS = -lc -lm -lgcc

# Build target
build: firmware.bin

# Convert ELF to binary
firmware.bin: firmware.elf
	arm-none-eabi-objcopy -O binary $< $@

# Link object files to create .elf file
firmware.elf: main.o
	arm-none-eabi-gcc $(LDFLAGS) $^ $(LIBS) -o $@

# Compile C source file to object file
main.o: main.c
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@

# Flash firmware to MCU
stmflash: firmware.bin
	stflash --reset write $< 0x08000000

# Clean build artifacts

clean:
	rm -f firmware.* *.o