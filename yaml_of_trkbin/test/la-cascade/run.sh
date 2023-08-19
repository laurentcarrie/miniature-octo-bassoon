#!/usr/bin/env sh

set -e
set -x

here=$(dirname $(realpath $0))
echo $here

trk_file=$here/la-cascade.gpx

../../bin/yaml_of_trkbin.exe $trk_file

test -f $here/segments.mp
test -f $here/waypoints.mp


rm -f la-cascade.pdf
lualatex la-cascade.tex
test -f la-cascade.pdf

echo DONE
