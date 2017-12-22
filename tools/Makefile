#
# Makefile
# truong-d, 2017-01-21 18:30
#

all: htk sptk engine
	@echo "Makefile needs your attention"

htk:
	cd htk && \
		./configure --prefix=`pwd`/install CFLAGS="-DARCH=linux" --disable-hslab && \
		make -j 3 && make install

sptk:
	cd SPTK-3.9 && autoreconf -f -i && \
		./configure --prefix=`pwd`/install && \
		make -j 5 && make install

engine:
	cd hts_engine_API-1.10 && autoreconf -f -i  && ./configure --prefix=`pwd`/install && make -j 3 && make install
.PHONY: htk sptk
# vim:ft=make
#
