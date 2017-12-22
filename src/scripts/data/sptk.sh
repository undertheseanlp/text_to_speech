#! /bin/bash
#
# run.sh
# Copyright (C) 2017 truongdo <truongdo@vais.vn>
#
# Distributed under terms of the modified-BSD license.
#

root=`dirname $0`
source Config.cfg

BYTEPERFRAME=`expr 4 \* \( $MGCWINDIM + $LF0WINDIM \)`
wav=$1
index=$2
datadir=$3
lf0dir=$datadir/lf0
mgcdir=$datadir/mgc
cmpdir=$datadir/cmp
base=`basename $wav .wav`
raw=/tmp/${index}.raw
sox $wav $raw || exit 1

x2x +sf $raw | pitch -H $file_maxf0 -L $file_minf0 -p $fs -s $SAMPKHZ -o 2 > $lf0dir/${base}.lf0 || exit 1
x2x +sf $raw | frame -l $fl -p $fs  | window -l $fl -L $FFTLEN -w $WINDOWTYPE -n $NORMALIZE | \
    mcep -a $FREQWARP -m $MGCORDER -l $FFTLEN -e 1.0E-08 > $mgcdir/${base}.mgc || exit 1

if [[ -n "`nan $lf0dir/${base}.lf0`" ]]; then
    echo " Failed to extract f0 features from $base";
fi

if [[ -n "`nan $mgcdir/${base}.mgc`" ]]; then
    echo " Failed to extract mgc features from $base";
fi

perl $root/../window.pl $MGCDIM $mgcdir/${base}.mgc $root/../win/mgc.win1 $root/../win/mgc.win2 $root/../win/mgc.win3 > /tmp/${index}.mgc.temp || exit 1
perl $root/../window.pl $LF0DIM $lf0dir/${base}.lf0 $root/../win/lf0.win1 $root/../win/lf0.win2 $root/../win/lf0.win3 > /tmp/${index}.lf0.temp || exit 1
merge +f -s 0 -l $LF0WINDIM -L ${MGCWINDIM} /tmp/${index}.mgc.temp < /tmp/${index}.lf0.temp > /tmp/${index}.cmp || exit 1
perl $root/../addhtkheader.pl $SAMPFREQ $fs $BYTEPERFRAME 9 /tmp/${index}.cmp > $cmpdir/${base}.cmp || exit 1
rm $raw /tmp/${index}.mgc.temp /tmp/${index}.lf0.temp /tmp/${index}.cmp
