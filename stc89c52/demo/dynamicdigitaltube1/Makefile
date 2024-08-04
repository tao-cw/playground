main.hex: main.rel
	sdcc -mmcs51 --Werror --std-c99 --out-fmt-ihx -o main.hex main.rel

main.rel: main.c
	sdcc -mmcs51 --Werror --std-c99 --out-fmt-ihx -c main.c -o main.rel

clean:
	rm -v main.asm main.lst main.rel main.sym main.hex main.lk main.map main.mem main.rst

upload:
	stcgal -P stc89a -p /dev/ttyUSB0 main.hex
