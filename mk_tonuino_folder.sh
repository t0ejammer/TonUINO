#!/bin/bash

DESTFOLDER="sdcard"

SRCFOLDER=$2
DESTNUM=$(printf "%02g" $1)

DESTINATION=$(realpath $DESTFOLDER/$DESTNUM)
ORIGIN=$(pwd)

# check destination folder existence, otherwise create it
if [ ! -e $DESTINATION ]; then
    mkdir -p $DESTINATION
else
    echo "WARNING : Removing contents of $DESTINATION"
    rm -f $DESTINATION/*
fi

# going into the source folder and copying each file to the destination number folder
cd "$SRCFOLDER"
for f in *.mp3
do
    if [[ $f == *"Titelnummer"* ]]; then # Windows Media Player extracted w/o Info
	DELIM=' '
    else
	DELIM='_'
    fi
    cp "$f" $DESTINATION/$(printf "%03g.mp3" $(cut -d"$DELIM" -f1 <<< $f))
done
# return to origin
cd $ORIGIN

# update database file
NAME="$(cut -d'/' -f1 <<< $SRCFOLDER) - $(cut -d'/' -f2 <<< $SRCFOLDER)"
sed -i "s/$DESTNUM.*/$DESTNUM $NAME/" sdcard.txt

