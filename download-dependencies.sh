#!/bin/bash

if [ ! -e x264 ]; then
    echo Fetching x264...
	git clone --depth 1 git://git.videolan.org/x264.git x264
else
    echo Updating x264...
	(cd x264 && git pull)
fi

if [ ! -e ffmpeg ]; then
    echo Fetching ffmpeg
	git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg
else
    echo Updating ffmpeg... 
	(cd ffmpeg && git pull)
fi


# vim: ts=4 sw=4 noexpandtab softtabstop=4 ai
