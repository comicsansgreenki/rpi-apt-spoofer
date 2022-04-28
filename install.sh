#!/bin/bash

echo "The purpose of this (patched together) program is to transmit images over radio"
echo "via the same method as the NOAA satellites, and is only recommended for experiments."
echo "I can't make any guarantees that this will work. I guess I'm saying it's an AS-IS thing,"
echo "but I still gotta read into that stuff."
echo "Also, you're doing this at YOUR OWN RISK, like pretty much everything else."
echo " "
printf "You got that? [y/n]"
read RESPONSE
if [ "$RESPONSE" = "y" ]; then
 printf "You sure you got that? [y/n]"
 read LRESPONSE
 if [ "$LRESPONSE" = "n" ]; then
  echo "Oh. Uhhh..."
  sleep $RANDOM
  echo "Byebye."
  exit 1
 fi
else
 echo "THEN READ IT OVER AGAIN IT'S ON THE SCREEN"
 exit 1
fi
echo "Okay, good. But nevertheless, BE CAREFUL!"
echo " "
echo "## Step 1: Install dependencies."
sudo apt install libsndfile1-dev git imagemagick libfftw3-dev libreadline-dev ffmpeg

# We're using CSDR as a dsp for analog modes thanks to HA7ILM
git clone https://github.com/F5OEO/csdr
cd csdr || exit
make && sudo make install
cd ../ || exit

cd src || exit
git clone https://github.com/F5OEO/librpitx
cd librpitx/src || exit
make
cd ../../ || exit

make
sudo make install
cd .. || exit

printf "\n\n"
echo "But I wasn't done yet. o>o"
echo " "
echo "Here's another prompt..."
echo "The rpitx side of this program uses the GPU to drive the transmission."
echo "When the GPU frequency changes (i.e. undervolting), so does the" 
echo "transmission, causing it to malfunction."
echo " "
echo "Prevent this issue and set the GPU frequency to 250 MHz,"
echo "or are you confident enough in your power supply?"
printf "[y/n] "
read -r CONT

if [ "$CONT" = "y" ]; then
  echo "Setting GPU frequency to 250 MHz."
   LINE='gpu_freq=250'
   FILE='/boot/config.txt'
   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
   #PI4
   LINE='force_turbo=1'
   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
   echo "Setup completed for rpitx."
else
  echo "Alright. If you change your mind, write this line to /boot/config.txt:"
  echo "gpu_freq=250"
fi
echo "## Step 2: Build apt-encoder"
sleep 0.5
cd ./apt-encoder
make
mv ./apt-encoder/Debug/noaa_apt ./aptencoder
make clean
cd ../
echo " "
echo "All set! Have...fun? o>O"
echo "And I'm sorry I had to throw 2 huge prompts at you...it's a big (sometimes legal) thing when you're dealing with actual radio transmissions."
exit 0
