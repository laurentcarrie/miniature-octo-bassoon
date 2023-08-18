#!/usr/bin/env sh

set -e
#set -x

here=$(dirname $(realpath $0))
echo $here

#trk_file=$here/triangle.gpx
trk_file=$here/le-carrosse.gpx
#trk_file=$here/marly.gpx
mp_file=$here/marly.mp

width=100
height=50
x0=0
y0=0
ratio=1.0
../../bin/yaml_of_trkbin.exe $trk_file $mp_file $width $height $x0 $y0   $ratio

test -f $mp_file
#mpost --tex=lualatex $mp_file

lualatex marly.tex

test -f marly.pdf

echo DONE
