CODE ?= main
CC = avr-gcc
MCU = atmega32
AVRDUDE_SHORT_CODE = m32
PROGRAMMER = usbasp
PORT = usb
CFLAGS =-Wall -Wextra -g -Os -mmcu=$(MCU) 

default: $(CODE).hex
	avr-size -C --mcu=$(MCU) $(CODE).elf

$(CODE).elf: $(CODE).o
	$(CC) $(CFLAGS) -o $@ $^

$(CODE).hex: $(CODE).elf
	avr-objcopy -O ihex $< $@

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm $(CODE) $(CODE).o $(CODE).elf $(CODE).hex

flash: $(CODE).hex
	avrdude -P $(PORT) -p $(AVRDUDE_SHORT_CODE) -c $(PROGRAMMER) -U flash:w:$(CODE).hex
