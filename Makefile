CC = cc
AR = ar
CPPFLAGS = -Iinclude
CFLAGS = -O2 -std=c99 -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Werror
LDFLAGS =
PREFIX = /usr/local
BUILD = build

.PHONY: all test sanitize clean install fuzz-smoke
all: $(BUILD)/libcupidmime.a $(BUILD)/cupidmime
$(BUILD):
	mkdir -p $(BUILD)
$(BUILD)/cupidmime.o: src/cupidmime.c src/zip.h include/cupidmime.h | $(BUILD)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
$(BUILD)/zip.o: src/zip.c src/zip.h include/cupidmime.h | $(BUILD)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
$(BUILD)/libcupidmime.a: $(BUILD)/cupidmime.o $(BUILD)/zip.o
	$(AR) rcs $@ $^
$(BUILD)/cupidmime: src/cli.c $(BUILD)/libcupidmime.a
	$(CC) $(CPPFLAGS) $(CFLAGS) $< $(BUILD)/libcupidmime.a $(LDFLAGS) -o $@
$(BUILD)/test: tests/test.c $(BUILD)/libcupidmime.a
	$(CC) $(CPPFLAGS) $(CFLAGS) $< $(BUILD)/libcupidmime.a $(LDFLAGS) -o $@
$(BUILD)/test-zip: tests/zip.c tests/zip_fixtures.h $(BUILD)/libcupidmime.a
	$(CC) $(CPPFLAGS) $(CFLAGS) $< $(BUILD)/libcupidmime.a $(LDFLAGS) -o $@
test: all $(BUILD)/test $(BUILD)/test-zip
	./$(BUILD)/test
	./$(BUILD)/test-zip
	CUPIDMIME="$(abspath $(BUILD)/cupidmime)" sh tests/cli.sh
sanitize:
	$(MAKE) test BUILD=build/sanitize CC=clang CFLAGS='-O1 -g -std=c99 -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Werror -fsanitize=address,undefined -fno-omit-frame-pointer' LDFLAGS='-fsanitize=address,undefined'
$(BUILD)/fuzz: tests/fuzz.c src/cupidmime.c src/zip.c src/zip.h include/cupidmime.h | $(BUILD)
	clang $(CPPFLAGS) -std=c99 -O1 -g -fsanitize=fuzzer,address,undefined tests/fuzz.c src/cupidmime.c src/zip.c -o $@
fuzz-smoke: $(BUILD)/fuzz $(BUILD)/test-zip
	BUILD_DIR="$(BUILD)" sh tests/fuzz.sh
install: all
	install -d $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/lib $(DESTDIR)$(PREFIX)/include
	install -m 755 $(BUILD)/cupidmime $(DESTDIR)$(PREFIX)/bin/
	install -m 644 $(BUILD)/libcupidmime.a $(DESTDIR)$(PREFIX)/lib/
	install -m 644 include/cupidmime.h $(DESTDIR)$(PREFIX)/include/
clean:
	rm -rf build
