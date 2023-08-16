#!/usr/bin/env sh

set -e
#set -x

here=$(dirname $(realpath $0))
echo $here

trk_file=$here/marly.gpx

../../bin/yaml_of_trkbin.exe $trk_file

echo DONE
