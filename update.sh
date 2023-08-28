#!/bin/sh

set -e
set -x 

here=$(dirname $(realpath $0))
libdir=$here/gpx_plot

echo "" > $here/format.txt
echo "" > $here/build.txt
echo "" > $here/test.txt


dune clean --root $libdir
dune build @fmt --auto-promote --root $libdir -j 1 2>&1 $here/format.txt || true
dune build @fmt --auto-promote --root $libdir -j 1 2>&1 $here/format.txt
dune build --root $libdir  > $here/build.txt 2>&1
dune build --root $libdir @doc
dune test --root $libdir  > $here/test.txt 2>&1
echo DONE


