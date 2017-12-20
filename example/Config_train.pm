#!/usr/bin/perl
# ----------------------------------------------------------------- #
#           The HMM-Based Speech Synthesis System (HTS)             #
#           developed by HTS Working Group                          #
#           http://hts.sp.nitech.ac.jp/                             #
# ----------------------------------------------------------------- #
#                                                                   #
#  Copyright (c) 2001-2015  Nagoya Institute of Technology          #
#                           Department of Computer Science          #
#                                                                   #
#                2001-2008  Tokyo Institute of Technology           #
#                           Interdisciplinary Graduate School of    #
#                           Science and Engineering                 #
#                                                                   #
# All rights reserved.                                              #
#                                                                   #
# Redistribution and use in source and binary forms, with or        #
# without modification, are permitted provided that the following   #
# conditions are met:                                               #
#                                                                   #
# - Redistributions of source code must retain the above copyright  #
#   notice, this list of conditions and the following disclaimer.   #
# - Redistributions in binary form must reproduce the above         #
#   copyright notice, this list of conditions and the following     #
#   disclaimer in the documentation and/or other materials provided #
#   with the distribution.                                          #
# - Neither the name of the HTS working group nor the names of its  #
#   contributors may be used to endorse or promote products derived #
#   from this software without specific prior written permission.   #
#                                                                   #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND            #
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,       #
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF          #
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          #
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS #
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,          #
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   #
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     #
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON #
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,   #
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    #
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE           #
# POSSIBILITY OF SUCH DAMAGE.                                       #
# ----------------------------------------------------------------- #


# Settings ==============================
$fclf        = 'VI_VAIS';
$fclv        = '1.0';
$spkr        = 'minhnguyet';
$qnum        = '001';
$ver         = '1';
$usestraight = '0';

@SET        = ('cmp','dur');
@cmp     = ('mgc','lf0');  # 'bap'
@dur        = ('dur');
$ref{'cmp'} = \@cmp;
$ref{'dur'} = \@dur;

%vflr = ('mgc' => '0.01',           # variance floors
         'lf0' => '0.01',
         'bap' => '0.01',
         'dur' => '0.01');

%thr  = ('mgc' => '000',            # minimum likelihood gain in clustering
         'lf0' => '000',
         'bap' => '000',
         'dur' => '000');

%mdlf = ('mgc' => '1.0',            # tree size control param. for MDL
         'lf0' => '1.0',
         'bap' => '1.0',
         'dur' => '1.0');

%mocc = ('mgc' => '10.0',           # minimum occupancy counts
         'lf0' => '10.0',
         'bap' => '10.0',
         'dur' => ' 5.0');

%gam  = ('mgc' => '000',            # stats load threshold
         'lf0' => '000',
         'bap' => '000',
         'dur' => '000');

%t2s  = ('mgc' => 'cmp',            # feature type to mmf conversion
         'lf0' => 'cmp',
         'bap' => 'cmp',
         'dur' => 'dur');

%strb = ('mgc' => '1',     # stream start
         'lf0' => '2',
         'bap' => '5',
         'dur' => '1');

%stre = ('mgc' => '1',     # stream end
         'lf0' => '4',
         'bap' => '7',
         'dur' => '5');

%msdi = ('mgc' => '0',              # msd information
         'lf0' => '1',
         'bap' => '1',
         'dur' => '0');

%strw = ('mgc' => '1.0',            # stream weights
         'lf0' => '1.0',
         'bap' => '0.0',
         'dur' => '1.0');

%ordr = ('mgc' => '25',     # feature order
         'lf0' => '1',
         'bap' => '1',
         'dur' => '5');

%nwin = ('mgc' => '3',      # number of windows
         'lf0' => '3',
         'bap' => '3',
         'dur' => '0');

%gvthr  = ('mgc' => '000',          # minimum likelihood gain in clustering for GV
           'lf0' => '000',
           'bap' => '000');

%gvmdlf = ('mgc' => '1.0',          # tree size control for GV
           'lf0' => '1.0',
           'bap' => '1.0');

%gvgam  = ('mgc' => '000',          # stats load threshold for GV
           'lf0' => '000',
           'bap' => '000');

%nblk = ('mgc' => '3', # number of blocks for transforms
         'lf0' => '1',
         'bap' => '1',
         'dur' => '1');

%mspfe  = ('mgc' => '1.0');         # emphasis coefficient of modulation spectrum-based postfilter

@slnt = ('sil','pau','h#','brth');        # silent and pause phoneme

# Speech Analysis/Synthesis Setting ==============
# speech analysis
$sr = 16000;   # sampling rate (Hz)
$fs = 80; # frame period (point)
$fw = 0.42;   # frequency warping
$gm = 0;      # pole/zero representation weight
$lg = 1;     # use log gain instead of linear gain

# speech synthesis
$pf_mcp = 1.4; # postfiltering factor for mel-cepstrum
$pf_lsp = 0.7; # postfiltering factor for LSP
$fl     = 1024;        # length of impulse response
$co     = 2047;            # order of cepstrum to approximate mel-cepstrum

# Modeling/Generation Setting ==============
# modeling
$nState      = 5;        # number of states
$nIte        = 5;         # number of iterations for embedded training
$beam        = '1500 100 5000'; # initial, inc, and upper limit of beam width
$maxdev      = 10;        # max standard dev coef to control HSMM maximum duration
$mindur      = 5;        # min state duration to be evaluated
$wf          = 5000;        # mixture weight flooring
$initdurmean = 3.0;             # initial mean of state duration
$initdurvari = 10.0;            # initial variance of state duration
$daem        = 1;          # DAEM algorithm based parameter estimation
$daem_nIte   = 10;     # number of iterations of DAEM-based embedded training
$daem_alpha  = 1.0;     # schedule of updating temperature parameter for DAEM

# generation
$pgtype     = 0;     # parameter generation algorithm (0 -> Cholesky,  1 -> MixHidden,  2 -> StateHidden)
$maxEMiter  = 20;  # max EM iteration
$EMepsilon  = 0.0001;  # convergence factor for EM iteration
$useGV      = 1;      # turn on GV
$maxGViter  = 50;  # max GV iteration
$GVepsilon  = 0.0001;  # convergence factor for GV iteration
$minEucNorm = 0.01; # minimum Euclid norm for GV iteration
$stepInit   = 1.0;   # initial step size
$stepInc    = 1.2;    # step size acceleration factor
$stepDec    = 0.5;    # step size deceleration factor
$hmmWeight  = 1.0;  # weight for HMM output prob.
$gvWeight   = 1.0;   # weight for GV output prob.
$optKind    = 'NEWTON';  # optimization method (STEEPEST, NEWTON, or LBFGS)
$nosilgv    = 1;    # GV without silent and pause phoneme
$cdgv       = 1;       # context-dependent GV


# Directories & Commands ===============
# project directories
$prjdir = 'exp/model';
$srcdir = '..//src/scripts';
$datdir = 'exp/data';

# Parallel training
$parallel = 1;
$nj = 1;
$split = "$srcdir/split.py";
eval {require Parallel::ForkManager};
if($@) { $parallel = 0; print "Module Parallel::ForkManager is not installed\n using only single cpu for training\n";}
else { print "Using parallel training with $nj cpus\n"; }
# Perl
$PERL = 'perl';

# wc
$WC = 'wc';

# HTS commands
$HCOMPV    = 'HCompV';
$HLIST     = 'HList';
$HINIT     = 'HInit';
$HREST     = 'HRest';
$HEREST    = 'HERest';
$HHED      = 'HHEd';
$HSMMALIGN = 'HSMMAlign';
$HMGENS    = 'HMGenS';
$ENGINE    = 'hts_engine';

# SPTK commands
$X2X          = 'x2x';
$FREQT        = 'freqt';
$C2ACR        = 'c2acr';

$VOPR       = "vopr";
$MC2B       = "mc2b";
$SOPR       = "sopr";
$B2MC       = "b2mc";
$EXCITE     = "excite";
$LSP2LPC    = "lsp2lpc";
$MGC2MGC    = "mgc2mgc";
$MGLSADF    = "mglsadf";
$MERGE      = "merge";
$BCP        = "bcp";
$LSPCHECK   = "lspcheck";
$BCUT       = "bcut";
$VSTAT      = "vstat";
$NAN        = "nan";
$DFS        = "dfs";
$SWAB       = "swab";
$NRAND      = "nrand";

$VSUM         = 'vsum';
$MGC2SP       = 'mgc2sp';
$RAW2WAV      = 'raw2wav';
$FRAME        = 'frame';
$WINDOW       = 'window';
$SPEC         = 'spec';
$TRANSPOSE    = 'transpose';
$PHASE        = 'phase';
$IFFTR        = 'ifftr';

# Switch ================================
$MKEMV = 1; # preparing environments
$HCMPV = 1; # computing a global variance
$IN_RE = 1; # initialization & reestimation
$MMMMF = 1; # making a monophone mmf
$ERST0 = 1; # embedded reestimation (monophone)
$MN2FL = 1; # copying monophone mmf to fullcontext one
$ERST1 = 1; # embedded reestimation (fullcontext)
$CXCL1 = 1; # tree-based context clustering
$ERST2 = 1; # embedded reestimation (clustered)
$UNTIE = 1; # untying the parameter sharing structure
$ERST3 = 1; # embedded reestimation (untied)
$CXCL2 = 1; # tree-based context clustering
$ERST4 = 1; # embedded reestimation (re-clustered)
$FALGN = 1; # forced alignment for no-silent GV
$MCDGV = 1; # making global variance
$CONVM = 1; # converting mmfs to the hts_engine file format

1;
