#!/usr/bin/env sh

set -e
set -x

here=$(dirname $(realpath $0))
bindir=$(dirname $(dirname $here))/bin
echo $here

test -d $bindir

rm -f main.pdf

$bindir/cli/gpx_plot_cli.exe $here

for f in gpx.mp waypoints.mp main.tex ; do
  test -f $here/$f || (echo $f is missing && false)
done
#lualatex main.tex
test -f main.pdf

echo DONE
