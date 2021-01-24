#!/bin/sh

echo "The purpose of this (patched together) program is to transmit images over radio"
echo "via the same method as the NOAA satellites, and is only recommended for experiments."
echo "I also won't be held liable for any damage you did or for any rules you violated."
echo "If you use this software, you're using it at your own risk."
echo " "
printf "You got that? [y/n]"
read RESPONSE
if [ "$RESPONSE" = "y" ]; then
 printf "You sure you got that? [y/n]"
 read LRESPONSE
 if [ "$LRESPONSE" = "n" ]; then
  echo "Okay. Don't see you later!"
  exit 0
 fi
else
 echo "THEN READ IT OVER AGAIN IT'S ON THE SCREEN"
 exit 0
fi
echo "Okay, good. But nevertheless, BE CAREFUL!"
echo " "
echo "## Step 1: Install dependencies"
sleep 1
sudo apt-get update
sudo apt-get install -y libsndfile1-dev git
sudo apt-get install -y imagemagick libfftw3-dev
sudo apt-get install -y ffmpeg pulseaudio pulseaudio-tools 

# We use CSDR as a dsp for analogs modes thanks to HA7ILM
git clone https://github.com/F5OEO/csdr
cd csdr || exit
make && sudo make install
cd ../ || exit

cd src || exit
git clone https://github.com/F5OEO/librpitx
cd librpitx/src || exit
make
cd ../../ || exit

cd pift8
git clone https://github.com/kgoba/ft8_lib
cd ../

make
sudo make install
cd .. || exit

printf "\n\n"
echo "But I wasn't done yet."
echo " "
echo "See, there's another issue:"
echo "The apt-spoofer TX side uses the GPU to drive the transmission."
echo "When the GPU frequency changes (i.e. undervolting), so does the" 
echo "transmission, causing it to malfunction."
echo " "
echo "Do you wanna prevent such an issue and set the GPU frequency to 250 MHz?"
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
   echo "Setup completed for the TX side"
else
  echo "### WARNING: TX will malfunction if your Raspberry Pi";
  echo "### is undervolted. BE CAREFUL AGAIN!"
fi
echo "## Step 2: Setup the signal encoder"
sleep 0.5
cd ./apt-encoder
make
mv ./apt-encoder/Debug/noaa_apt ./aptencoder
make clean
cd ../
echo "## All set! Don't have fun! "
echo "## And I'm sorry I had to throw 2 huge prompts at you...it's a big (sometimes legal) thing when you're dealing with actual radio transmissions."
