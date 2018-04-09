#!/bin/sh

# requires: feh, xrandr
# make sure you have both of these programs
#
# this will dipslay the art in the folder of currently playing track in a slideshow
# either in full screen mode or on attached display in full screen mode. it will decide for you.
# so make sure you fill your folders with a ton of cool art.
# it will dipslay the slideshow for as long as the duration of the track
#
# if you change the variable FULLSCREEN below to "Yes" this will display the slideshow on the primary
# display only. Good for when you mirror displays or don't have another monitor attached.
# set to 'No' it will display fullscreen on attached dispalys.  
#
# written by: bubonic 
# 2018


#edit to "Yes" or "No"
FULLSCREEN="No"

status=$2
file_path=`echo $4 | sed 's/file //' | sed 's:^\(.*\)/.*$:\1:'`/
duration=`cmus-remote -Q | grep "duration" | sed 's/duration //'`
VGADISPLAY=`xrandr | grep "VGA-1" | awk '{print $2}'`
HDMIDISPLAY=`xrandr | grep "HDMI-1" | awk '{print $2}'`
DPDISPLAY=`xrandr | grep "DP-1" | awk '{print $2}'`

if [ $VGADISPLAY = "connected" ]; then
	DIMENSION=`xrandr | grep "VGA-1" | awk '{print $3}'`
fi

if [ $HDMIDISPLAY = "connected" ]; then
	DIMENSION=`xrandr | grep "HDMI-1" | awk '{print $3}'`
fi

if [ $DPDISPLAY = "connected" ]; then
	DIMENSION=`xrandr | grep "DP-1" | awk '{print $3}'`
fi
if [ $status = "playing" ]; then
	#COVER_PHOTO=`ls -as "$file_path" | grep ".jpg\|.jpeg\|.png" | sort -g | tail -1 | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}'`
	if [ $FULLSCREEN = "Yes" ]; then
		feh -x -D5 -F -Z -B black "$file_path" &
	else
		feh -x -D5 -g $DIMENSION -Z -B black "$file_path" &
	fi
	pid=$!
	sleep $duration
	kill $pid
else
	pkill feh
fi

