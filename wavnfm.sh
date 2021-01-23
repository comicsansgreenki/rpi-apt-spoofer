#!/bin/sh

#(while true; do cat sampleaudio.wav; done) | csdr convert_i16_f | csdr gain_ff 2500 | sudo ./sendiq -i /dev/stdin -s 24000 -f 434e6 -t float 1

if ( "$3" = "-c" ); then
	echo "**Converting file**"
	ffmpeg -i "$2" -ac 1 -ar 48000 -acodec s16_le temp.wav
        echo "**Transmitting! Ctrl+C to stop before end**"
	(cat temp.wav) | csdr convert_i16_f \
	  | csdr gain_ff 7000 | csdr convert_f_samplerf 20833 \
	  | sudo rpitx -i- -m RF -f "$1"
        rm temp.wav
else
	echo "**Transmitting! Ctrl+C to stop before end**"
	(cat "$2") | csdr convert_i16_f \
          | csdr gain_ff 7000 | csdr convert_f_samplerf 20833 \
          | sudo rpitx -i- -m RF -f "$1"
fi
exit 0
