#!/bin/sh
if [[ "$1" = "137100" ]]; then
	echo "** WARNING: Transmission frequency overlaps NOAA-19! (input freq: $1)"
	echo "**          Please make sure that your radio transmissions are well-contained."
	echo "**          Otherwise, you may be in some *very bad legal doodoo.*"
	echo "**"
	echo "**          YOU HAVE BEEN WARNED . . ."
	echo " "
fi
if [[ "$1" = "137620" ]]; then
	echo "** WARNING: Transmission frequency overlaps NOAA-15! (input freq: $1)"
	echo "**          Please make sure that your radio transmissions are well-contained."
	echo "**          Otherwise, you may be in some *very bad legal doodoo.*"
	echo "**"
	echo "**          YOU HAVE BEEN WARNED . . ."
	echo " "
fi
if [[ "$1" = "137900" ]]; then
	echo "** WARNING: Transmission frequency overlaps NOAA-18! (input freq: $1)"
	echo "**          Please make sure that your radio transmissions are well-contained."
	echo "**          Otherwise, you may be in some *very bad legal doodoo.*"
	echo "**"
	echo "**          YOU HAVE BEEN WARNED . . ."
	echo " "
fi
### Even then, make sure they're well-contained unless you plan on transmitting with a good low-pass filter.

if ( "$3" = "-c" ); then
	echo "Converting file via ffmpeg ..."
	ffmpeg -i "$2" -ac 1 -ar 48000 -acodec s16_le /tmp/rpi-apt-spoofer.wav
        echo "** Transmitting! **"
	echo "Type ^C to stop."
	(cat /tmp/rpi-apt-spoofer.wav) | csdr convert_i16_f \
	  | csdr gain_ff 7000 | csdr convert_f_samplerf 20833 \
	  | sudo rpitx -i- -m RF -f "$1"
        rm /tmp/rpi-apt-spoofer.wav
else
	echo "** Transmitting! **"
	echo "Type ^C to stop."
	(cat "$2") | csdr convert_i16_f \
          | csdr gain_ff 7000 | csdr convert_f_samplerf 20833 \
          | sudo rpitx -i- -m RF -f "$1"
fi
exit 0
