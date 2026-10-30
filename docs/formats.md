# Format coverage

This table describes the checks in the source. A structural result means these particular checks passed; it does not mean the whole file is valid.

| Family | Returned type | Checks and remaining limits |
| --- | --- | --- |
| PNG | `image/png` | Signature, complete IHDR extent, length, dimensions, color/bit-depth combinations, compression/filter/interlace fields; CRC and later chunks unchecked |
| GIF | `image/gif` | 87a/89a signature, logical screen header, nonzero dimensions; tables and frames unchecked |
| JPEG | `image/jpeg` | Start-of-image and marker prefix; segments and image data unchecked |
| WebP | `image/webp` | RIFF extent, first chunk tag and chunk extent within RIFF; codec payload and padding unchecked |
| WAVE | `audio/wav` | RIFF extent and WAVE form; audio chunks unchecked |
| AVI | `video/x-msvideo` | RIFF extent and AVI form; stream chunks unchecked |
| ZIP | `application/zip` | Local header, nonempty filename, variable header extent, compressed extent when available; or empty end record; directory consistency, CRC, encryption and ZIP64 unchecked |
| gzip | `application/gzip` | Fixed header, DEFLATE method and reserved bits; optional fields, payload and trailer unchecked |
| PDF | `application/pdf` | Offset-zero version line with major 1 or 2 and one decimal minor digit; objects and EOF unchecked |
| ELF | `application/x-elf` | Identification, class, byte order, version and file header length; type and section tables unchecked |
| SQLite | `application/vnd.sqlite3` | Database magic, 100-byte header, page size, read/write versions and payload fractions; pages unchecked |
| WebAssembly | `application/wasm` | Magic and version 1; sections unchecked |
| ISO BMFF | `video/mp4`, `audio/mp4`, `image/avif` | Complete 32-bit ftyp box, alignment, major and compatible brands; extended boxes and media tracks unsupported |
| ustar | `application/x-tar` | 512-byte header, ustar marker and unsigned header checksum; members and archive termination unchecked |
| JSON | `application/json` | Complete UTF-8 object or array, bounded grammar parser; policy details in [detection](detection.md) |
| HTML | `text/html` | Selected leading tokens and delimiters; not a document validator |
| XML | `application/xml` | Declaration prefix; not a document validator |
| Text | `text/plain` | ASCII/UTF-8 policy; no charset parameter inferred |
| Other or empty | `application/octet-stream` | Conservative fallback |

`application/x-elf`, `application/x-tar`, and `video/x-msvideo` are compatibility names; they should not be read as a claim that all returned names are registered with IANA. Aliases and subclass queries are not part of this API.

Current gaps include ZIP subtypes, full archive consistency, Ogg/FLAC/MP3, WebM, fonts, PE executables, legacy text encodings, and a representative external fixture corpus. See [open issues](https://github.com/cupidthecat/cupidMIME/issues) for scoped follow-up work. There is no claim of parity with libmagic or Shared MIME-info.
