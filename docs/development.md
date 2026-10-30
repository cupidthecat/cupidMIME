# Development

Work in Linux or WSL on the Linux filesystem. A normal build needs `make`, `ar`, and a C99 compiler. Runtime code uses only the C standard library. The test shell script uses ordinary POSIX tools. Clang sanitizers are development tools rather than library dependencies.

```sh
make clean
make test CC=gcc
make clean
make test CC=clang
make sanitize
make fuzz-smoke
clang --analyze -std=c99 -Iinclude src/cupidmime.c src/cli.c
```

Clean when changing compiler flags: make does not track command-line changes. The default flags treat warnings as errors. CI tests GCC and Clang independently and runs AddressSanitizer and UndefinedBehaviorSanitizer.

The tests build small byte fixtures in memory. They exercise valid headers, damaged fields, declared extents, truncated prefixes, JSON grammar, invalid UTF-8, bounded recursion, API errors, deterministic random buffers, and the scan limit. Every positive fixture is also inspected at each shorter length using an exact-sized heap allocation, through both complete and prefix APIs. These allocations make sanitizer checks useful for finding reads beyond the supplied buffer.

`make fuzz-smoke` uses Clang's libFuzzer with ASan/UBSan for 10,000 mutations, seeded with synthetic JSON, HTML, gzip, RIFF, BMFF and PNG buffers. It checks both APIs and basic result invariants. The smoke run is intentionally short; it does not establish exhaustive coverage. For a longer local run, build `build/fuzz` and run `./build/fuzz build/corpus -max_total_time=300`. Keep useful regression inputs with a test that explains the failure. A licensed real-world corpus and sustained fuzzing remain open work.

For a new rule, document the MIME name, source, evidence level, and fields checked. Add a positive fixture, a near-match, malformed length fields, and truncation cases around each field read. Keep stronger binary evidence ahead of text heuristics. Do not specialize containers from arbitrary embedded strings.

## Installation

```sh
make
make install PREFIX="$HOME/.local"
```

`DESTDIR` supports staging. Installation copies the CLI, public header, and static library. There is no shared-library ABI or package metadata yet.

## Documentation and wiki

Keep the README limited to purpose, build commands, a small API example, and documentation links. Put detailed behavior and limitations in `docs/`. The wiki is a navigation and orientation layer that links to those maintained files. Update the coverage and policy documents whenever behavior changes. Review prose for unsupported claims, filler, and repetitive structure before publishing it.
