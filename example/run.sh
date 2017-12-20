#! /bin/bash
#
# run.sh
# Copyright (C) 2017 truongdo <truongdo@vais.vn>
#
# Distributed under terms of the modified-BSD license.
#


. ./path.sh
here=`pwd`
stage=0
mkdir -p exp/data

if [[ $stage -le 0 ]]; then
    ./steps/make_feat.sh data exp/data || exit 1
fi

if [[ $stage -le 1 ]]; then
    ./steps/make_lab.sh data/txt exp/data || exit 1
    ./steps/make_lab.sh data/txt_gen exp/data_gen || exit 1
fi

if [[ $stage -le 2 ]]; then
    perl ../src/scripts/Training.pl $here/Config_train.pm || exit 1
fi

if [[ $stage -le 3 ]]; then
    mkdir -p exp/gen
    mdl=exp/model/voices/qst001/ver1/minhnguyet.htsvoice
    for lab in `ls exp/data_gen/labels/full/*.lab`;
    do
        base=`basename $lab .lab`
        echo "Generating wav for $base --> exp/gen"
        hts_engine -b 0.3 -m $mdl $lab -ow exp/gen/$base.wav
    done
fi
