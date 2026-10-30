#!/bin/sh
set -eu
mkdir -p build/corpus
printf '{"a":[true,false,null,-1.25e3,"hello"]}' > build/corpus/json
printf '<!doctype html><html></html>' > build/corpus/html
printf '\037\213\010\002\000\000\000\000\000\003\247\167\003\000\000\000\000\000\000\000\000\000' > build/corpus/gzip
printf 'RIFF\016\000\000\000WAVEJUNK\001\000\000\000x\000' > build/corpus/riff
printf '\000\000\000\030ftypisom\000\000\000\000avifisom' > build/corpus/bmff
printf '\211PNG\015\012\032\012\000\000\000\015IHDR\000\000\000\001\000\000\000\001\010\006\000\000\000\000\000\000\000' > build/corpus/png
./build/fuzz build/corpus -seed=12345 -runs=10000 -max_len=4096
