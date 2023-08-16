#!/usr/bin/env sh

set -e
#set -x

here=$(dirname $(realpath $0))

trk_file=$here/track_20230806_115655.trk

../../bin/yaml_of_trkbin.exe $trk_file

echo DONE
