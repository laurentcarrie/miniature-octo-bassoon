#!/usr/bin/env sh

set -e
set -x

here=$(dirname $(realpath $0))
echo $here

trk_file=$here/le-carrosse.gpx

../../bin/yaml_of_trkbin.exe $trk_file

test -f $here/segments.mp
test -f $here/waypoints.mp


rm -f marly.pdf
lualatex marly.tex
test -f marly.pdf

echo DONE
