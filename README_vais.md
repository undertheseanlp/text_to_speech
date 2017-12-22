# Introduction #
This repository provides all necessary toolkits and an example to train a speech synthesis system for Vietnamese.
It includes,

1. __HTK 3.4.1__ for training TTS models.
2. __HTS engine__ for decoding.
3. __SPTK__ for speech analysis.
4. __textana__ for Vietnamese text analysis.

Noted that the toolkits have been tested on ubuntu 14.04, gcc and g++ version __below 5.0__, but other linux distribution should also works well.

![Demo](http://imgh.us/output.gif "Demo")

# Installation #
* Installs dependencies,
```
apt-get install -y --no-install-recommends g++-multilib make csh sox python zip automake realpath
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Parallel::ForkManager'
```
* Installs toolkits,
```
cd tools && make
```

# Troubleshooting #
If you have troubles with perl like this,
```
   perl: warning: Falling back to a fallback locale ("en_US.UTF-8").
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = "en_US:en",
```

then, add the following lines to your `.bashrc` or `.zshrc`,
```
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

# Citation #
If you publish papers using this framework, please cite the following softwares,
```
  @misc{truong_vita,
    author = {Quoc Truong Do},
    title = {Vita: A Toolkit for Vietnamese segmentation, chunking, part of speech tagging and morphological analyzer},
    url = {http://truongdo.com/vita/},
    year = {2015}
  }
```
and also `hts_engine` and `SPTK`.
