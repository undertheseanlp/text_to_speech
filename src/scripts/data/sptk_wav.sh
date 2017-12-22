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
datadir=$1
odir=$2
mkdir -p $odir

mgcdir=$datadir/mgc
for mgc in `find $datadir -iname "*.mgc*" | sort`;
do
    base=`basename $mgc .mgc`
    echo $base
    lf0=`echo $mgc | sed "s/mgc/lf0/g"`
    sopr -magic -1.0E+10 -EXP -INV -m $SAMPFREQ -MAGIC 0.0 $lf0 > $odir/${base}.pit || exit 1

    lfil=`perl $root/../makefilter.pl $SAMPFREQ 0`
    hfil=`perl $root/../makefilter.pl $SAMPFREQ 1`

    sopr -m 0 $odir/${base}.pit | excite -n -p $fs | dfs -b $hfil > $odir/${base}.unv || exit 1
    excite -n -p $fs $odir/${base}.pit | dfs -b $lfil | vopr -a $odir/${base}.unv | \
        mglsadf -P 5 -m ${MGCORDER} -p $fs -a $FREQWARP -c 0 $mgc | \
        x2x +fs -o > $odir/${base}.raw || exit 1
    raw2wav -s $SAMPKHZ -d $odir $odir/${base}.raw || exit 1
    rm $odir/${base}.unv $odir/${base}.pit $odir/${base}.raw
done
