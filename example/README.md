# Introduction #
This repository provides an example to train a speech synthesis model based on HMM techniques for Vietnamese. It includes the following features,

1. __End-to-end training__. We only need to provide audios and their transcription. The toolkit will perform
parameters extraction, text analysis, etc.
2. __Support multi-thread training__. The data can be split into small chunks and processed in parallel.

For your reference, the synthetic audio results can be found in the `baseline_result` folder.

# Data
Because the data is quite large to put in the same repository, please
download it [here](https://www.dropbox.com/s/3pbc7l92bm6av3a/vais_hts_for_vietnamese_data.zip?dl=0) and extract it in this folder.

# Change configuration
Change the following variables in __Config_train.pm__ to your local path,

```
$prjdir = '/home/truong-d/workspace/vais/hts_sample/example/exp/model';
$srcdir = '/home/truong-d/workspace/vais/hts_sample/src/scripts';
$datdir = '/home/truong-d/workspace/vais/hts_sample/example/exp/data';
```

# Run with small data to check everything works properly #
`./run_small.sh`

# Run the full example with all data
`./run.sh`

# Speed up training process #
You can speed up the training process by increase the number of jobs run in parallel in the __Config_train.pm__ file,
```
$nj = 4;
```
