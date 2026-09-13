# Target binary
all: build/main.dump build/main.txt

# Create the build directory
build:
	mkdir -p build

# Assemble startup.s
build/startup.o: src/startup.s | build
	riscv64-unknown-elf-as -o build/startup.o src/startup.s -march=rv32im -mabi=ilp32

# Compile main.c with optimization
build/main.o: src/main.c | build
	riscv64-unknown-elf-gcc -c -o build/main.o src/main.c -march=rv32im -mabi=ilp32 -O2

# Link objects with optimization
build/main.elf: build/main.o build/startup.o linker.ld | build
	riscv64-unknown-elf-gcc -o build/main.elf build/main.o build/startup.o -T linker.ld -nostdlib -march=rv32im -mabi=ilp32 -O1

# Strip ELF
build/main.strip: build/main.elf
	riscv64-unknown-elf-strip build/main.elf -o build/main.strip

# Convert ELF to binary
build/main.bin: build/main.strip
	riscv64-unknown-elf-objcopy -O binary --only-section=.data* --only-section=.text* build/main.strip build/main.bin

# Run Python script
build/main.txt: build/main.bin
	python3 maketxt.py build/main.bin > build/main.txt

# Generate disassembly
build/main.dump: build/main.elf
	riscv64-unknown-elf-objdump -S -s build/main.elf > build/main.dump

clean:
	rm -rf build