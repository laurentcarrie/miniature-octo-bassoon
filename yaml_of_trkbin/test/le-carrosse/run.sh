#!/usr/bin/env sh

set -e
set -x

here=$(dirname $(realpath $0))
echo $here

trk_file=$here/le-carrosse.gpx

../../bin/yaml_of_trkbin.exe $trk_file

test -f $here/segments.mp
test -f $here/waypoints.mp


rm -f le-carrosse.pdf
lualatex le-carrosse.tex
test -f le-carrosse.pdf

echo DONE
