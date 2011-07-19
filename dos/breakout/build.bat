set CC=..\dm\bin\dmc
set MM=-ms
set LIB=.
%CC% input.c -c %MM%
%CC% video.c -c %MM%
%CC% breakout.c -c %MM%
%CC% breakout.obj input.obj video.obj -o breakout %MM%

