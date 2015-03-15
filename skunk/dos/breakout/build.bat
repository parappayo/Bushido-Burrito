set CC=..\dm\bin\dmc
set MM=-ml
set LIB=.
%CC% input.c -c %MM%
%CC% video.c -c %MM%
%CC% paddle.c -c %MM%
%CC% ball.c -c %MM%
%CC% blocks.c -c %MM%
%CC% breakout.c -c %MM%
%CC% breakout.obj input.obj video.obj paddle.obj ball.obj blocks.obj -o breakout %MM%

