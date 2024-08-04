led.hex: led.rel
	sdcc -mmcs51 --Werror --std-c99 --out-fmt-ihx -o led.hex led.rel

led.rel: led.c
	sdcc -mmcs51 --Werror --std-c99 --out-fmt-ihx -c led.c -o led.rel

clean:
	rm -v led.asm led.lst led.rel led.sym led.hex led.lk led.map led.mem led.rst

upload:
	stcgal -P stc89a -p /dev/ttyUSB0 led.hex
