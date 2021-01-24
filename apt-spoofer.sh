if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "-?" ]; then
 echo "Usage:"
 echo "apt-spoofer.sh [image] [frequency in KHz]"
 exit 0
fi

if [ -z "$1" ]; then
 echo "Oops! Did you try adding an image yet?"
 echo "(or try $0 --help)"
 exit 1
fi

if [ ! -f "$1" ]; then
 echo "$1: No such file or directory"
 echo "Try $0 --help."
 exit 1
fi

2>/dev/null ffmpeg -i $1 -vf scale=909:ih*640/iw temp.tga
./aptencoder -i temp.tga -d -r temp.wav
./wavnfm.sh $2 temp.wav -c
rm temp.tga
rm temp.wav
exit 0
