CC = cc
AR = ar
CPPFLAGS = -Iinclude
CFLAGS = -O2 -std=c99 -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Werror
LDFLAGS =
PREFIX = /usr/local

.PHONY: all test sanitize clean install fuzz-smoke
all: build/libcupidmime.a build/cupidmime
build:
	mkdir -p build
build/cupidmime.o: src/cupidmime.c include/cupidmime.h | build
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
build/libcupidmime.a: build/cupidmime.o
	$(AR) rcs $@ $<
build/cupidmime: src/cli.c build/libcupidmime.a
	$(CC) $(CPPFLAGS) $(CFLAGS) $< build/libcupidmime.a $(LDFLAGS) -o $@
build/test: tests/test.c build/libcupidmime.a
	$(CC) $(CPPFLAGS) $(CFLAGS) $< build/libcupidmime.a $(LDFLAGS) -o $@
test: all build/test
	./build/test
	sh tests/cli.sh
sanitize:
	$(MAKE) clean
	$(MAKE) test CC=clang CFLAGS='-O1 -g -std=c99 -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Werror -fsanitize=address,undefined -fno-omit-frame-pointer' LDFLAGS='-fsanitize=address,undefined'
build/fuzz: tests/fuzz.c src/cupidmime.c include/cupidmime.h | build
	clang $(CPPFLAGS) -std=c99 -O1 -g -fsanitize=fuzzer,address,undefined tests/fuzz.c src/cupidmime.c -o $@
fuzz-smoke: build/fuzz
	sh tests/fuzz.sh
install: all
	install -d $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/lib $(DESTDIR)$(PREFIX)/include
	install -m 755 build/cupidmime $(DESTDIR)$(PREFIX)/bin/
	install -m 644 build/libcupidmime.a $(DESTDIR)$(PREFIX)/lib/
	install -m 644 include/cupidmime.h $(DESTDIR)$(PREFIX)/include/
clean:
	rm -rf build
