all:
	sdas8051 -o led.rel led.asm
	sdld -i led.ihx led.rel
	packihx led.ihx > led.hex

clean:
	rm led.rel led.ihx led.hex
