#! /bin/bash
#
# make_lab.sh
# Copyright (C) 2017 truongdo <truongdo@vais.vn>
#
# Distributed under terms of the modified-BSD license.
#


. ./path.sh
if [[ $# -ne 2 ]]; then
    echo "Usages: $0 text-dir odir"
    exit 1
fi
datadir=$1
odir=$2
if [[ ! -f $datadir/text ]]; then
    echo "Expects file $datadir/text"
    exit 1
fi

mkdir -p $odir/labels/full $odir/labels/mono $odir/lists || exit 1
full_dir=`realpath $odir/labels/full`
mono_dir=`realpath $odir/labels/mono`
list_dir=`realpath $odir/lists`
text=`realpath $datadir/text`
vita_ana $textana/models $text $full_dir $mono_dir || exit 1

for file in `ls $full_dir/*.lab`;
do
    cat $file
    echo ""
done | sort -u | sed '/^$/d' > $list_dir/full.list || exit 1
cut -f 1 -d "+" $list_dir/full.list | cut -f 2 -d"-" | sort -u > $list_dir/mono.list || exit 1

echo """#!MLF!#
\"*/*.lab\" -> \"$full_dir\"""" > $full_dir/../full.mlf  # We use /data instead of $odir to make it compatible with tts-training container

echo """#!MLF!#
\"*/*.lab\" -> \"$mono_dir\"""" > $full_dir/../mono.mlf # We use /data instead of $odir to make it compatible with tts-training container

