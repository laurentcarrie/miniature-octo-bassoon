#!/usr/bin/env sh

set -e
set -x

here=$(dirname $(realpath $0))
echo $here

trk_file=$here/le-carrosse.gpx

../../bin/gpx_plot.exe conf.yml

for f in gpx.mp waypoints.mp main.tex ; do
  test -f $here/$f || (echo $f is missing && false)
done
rm -f main.pdf
lualatex main.tex
test -f main.pdf

echo DONE
