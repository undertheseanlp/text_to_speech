#! /bin/bash
#
# run_small.sh
# Copyright (C) 2017 truongdo <truongdo@vais.vn>
#
# Distributed under terms of the modified-BSD license.
#


. ./path.sh
here=`pwd`
exp="exp_10"
stage=0
mkdir -p $exp/data

if [[ $stage -le 0 ]]; then
    echo "=== Make Feature ==="
    START=$(date +%s);
    ./steps/make_feat.sh data_10 $exp/data || exit 1
    END=$(date +%s);
    MAKE_FEATURE_TIME=$((END - START))
    # Uncomment the line below to resynthesize audios from extracted speech parameters
    #../src/scripts/data/sptk_wav.sh exp/data exp/resyn || exit 1
fi


if [[ $stage -le 1 ]]; then
    echo "=== Make Lab ==="
    START=$(date +%s);
    ./steps/make_lab.sh data_10/txt $exp/data || exit 1
    ./steps/make_lab.sh data_10/txt_gen $exp/data_gen || exit 1
    END=$(date +%s);
    MAKE_LAB_TIME=$((END - START))
fi

if [[ $stage -le 2 ]]; then
    echo "=== Training ==="
    START=$(date +%s);
    echo `pwd`
    perl ../src/scripts/Training.pl $here/Config_train.pm || exit 1
    END=$(date +%s);
    TRAINING_TIME=$((END - START))
fi

if [[ $stage -le 3 ]]; then
    echo "=== Generate ==="
    START=$(date +%s);
    mkdir -p $exp/gen
    mdl=$exp/model/voices/qst001/ver1/minhnguyet.htsvoice
    for lab in `ls $exp/data_gen/labels/full/*.lab`;
    do
        base=`basename $lab .lab`
        echo "Generating wav for $base --> $exp/gen"
        hts_engine -b 0.4 -m $mdl $lab -ow $exp/gen/$base.wav
    done
    END=$(date +%s);
    GENERATE_TIME=$((END - START))
fi

log_file='exp.log'
echo "Make Feature Time:" > $log_file
echo $MAKE_FEATURE_TIME | awk '{print int($1/60)":"int($1%60)}' >> $log_file
echo "Make Lab Time:"  >> $log_file
echo $MAKE_LAB_TIME | awk '{print int($1/60)":"int($1%60)}' >> $log_file
echo "Training Time:"  >> $log_file
echo $TRAINING_TIME | awk '{print int($1/60)":"int($1%60)}'  >> $log_file
echo "Generate Time:"  >> $log_file
echo $GENERATE_TIME | awk '{print int($1/60)":"int($1%60)}'  >> $log_file