# Development

Work in Linux or WSL on the Linux filesystem. A normal build needs `make`, `ar`, and a C99 compiler. Runtime code uses only the C standard library. The test shell script uses ordinary POSIX tools. Clang sanitizers are development tools rather than library dependencies.

```sh
make clean
make test CC=gcc
make clean
make test CC=clang
make sanitize
clang --analyze -std=c99 -Iinclude src/cupidmime.c src/cli.c
```

Clean when changing compiler flags: make does not track command-line changes. The default flags treat warnings as errors. CI tests GCC and Clang independently and runs AddressSanitizer and UndefinedBehaviorSanitizer.

The tests build small byte fixtures in memory. They exercise valid headers, damaged fields, declared extents, truncated prefixes, JSON grammar, invalid UTF-8, bounded recursion, API errors, deterministic random buffers, and the scan limit. Exact-sized heap allocations make sanitizer checks useful for finding reads beyond the supplied buffer. Random tests supplement the focused cases; they do not replace a corpus or sustained fuzzing.

For a new rule, document the MIME name, source, evidence level, and fields checked. Add a positive fixture, a near-match, malformed length fields, and truncation cases around each field read. Keep stronger binary evidence ahead of text heuristics. Do not specialize containers from arbitrary embedded strings.

## Installation

```sh
make
make install PREFIX="$HOME/.local"
```

`DESTDIR` supports staging. Installation copies the CLI, public header, and static library. There is no shared-library ABI or package metadata yet.

## Documentation and wiki

Keep the README limited to purpose, build commands, a small API example, and documentation links. Put detailed behavior and limitations in `docs/`. The wiki is a navigation and orientation layer that links to those maintained files. Update the coverage and policy documents whenever behavior changes. Review prose for unsupported claims, filler, and repetitive structure before publishing it.
