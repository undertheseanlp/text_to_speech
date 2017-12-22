#! /bin/bash
#
# make_feat.sh
# Copyright (C) 2017 truongdo <truongdo@vais.vn>
#
# Distributed under terms of the modified-BSD license.
#
# This scripts extract speech parameters from audios
#


. ./path.sh
if [[ $# -ne 2 ]]; then
    echo "This script extract speech parameter from audios. Configuration can be found in the Config.cfg file."
    echo "Usages: $0 wav-dir odir"
    exit 1
fi
datadir=$1
odir=$2

PROGNAME=$(basename $0)
source Config.cfg || exit 1

function error_exit
{
        echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
        exit 1
}

echo "Output dir: $odir"
echo "Number of thread: $NUM_THREAD"
mkdir -p $odir
echo "Finding all wav file under $datadir/wav"
find $datadir/wav -iname "*.wav" | sort > $odir/wav.scp
nwav=`wc -l $odir/wav.scp | cut -f 1 -d" "`
if [[ $nwav -eq 0 ]]; then
    echo "Cannot find any wav file"
    exit 1
fi
echo "Found $nwav wav files"
# setting

function process
{
    wav=$1
	base=`basename $wav .wav`
	delim=/
    subDir=`echo $line | perl -F/ -wane 'print $F[-2]'`
	index=$2
	if [[ $subDir == "wav" ]]
	then
		subDir=""
	fi
    $scripts/data/sptk.sh $wav $index $odir $subDir  || exit 1 # Given audio and output folder, output mgc, lf0, [bap], and cmp file
}

debug() { echo "DEBUG: $*" >&2; }

waitall() { # PID...
  local errors=0
  while :; do
    for pid in "$@"; do
      shift
      if kill -0 "$pid" 2>/dev/null; then
        set -- "$@" "$pid"
      elif wait "$pid"; then
        continue
      else
        debug "$pid exited with non-zero exit status."
        ((++errors))
      fi
    done
    (("$#" > 0)) || break
    # TODO: how to interrupt this sleep when a child terminates?
    sleep ${WAITALL_DELAY:-1}
   done
  ((errors == 0))
}


rm -rf $odir/lf0 $odir/mgc $odir/bap $odir/cbap $odir/cmp 2>/dev/null
pids=""
idx=0
i=0
while read line
do
	((i++))
	base=`basename $line .wav`
	delim=/
	subDir=`echo $line | perl -F/ -wane 'print $F[-2]'`

	if [[ $subDir == "wav" ]]
        then
                subDir=""
        fi

	mkdir -p $odir/f0/$subDir
	mkdir -p $odir/lf0/$subDir
	mkdir -p $odir/mgc/$subDir
	mkdir -p $odir/cmp/$subDir

	echo "process file "$base
	((idx=$idx+1))
	process $line $idx &
	pids="$pids $!"
	if [ $i == $NUM_THREAD ]
	then
		waitall $pids
		i=0
		pids=""
	fi
done < $odir/wav.scp
wait

mkdir -p $odir/scp
find $odir/cmp -iname "*.cmp" | sort > $odir/scp/train.scp
