#!/bin/bash
rm -f  /tmp/list
rm -f  /tmp/page
read -p "Enter archive name: " -e -i "$RANDOM" archivename
archivenamenonespace=`echo $archivename | tr ' ' '_'`
mkdir $archivenamenonespace
cd $archivenamenonespace
read -p "Playlist(1) OR Channel(2) or SingleVideo(3)? [1/2/3]: " -e -i 2 todo
      if [[ "$todo" = '1' ]]; then
		addtoplaylisttrue="y"
		while [  $addtoplaylisttrue == "y" ]; do
			read -p "Enter Playlist URL: " playlisturl
            		echo $playlisturl | cut -d"=" -f3 >> /tmp/list
            		read -p "Add more? [y/n] " -e -i "y" addtoplaylisttrue
		done
            videofilename="%(playlist_uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"
            yesplaylist="--yes-playlist"
      fi
      if [[ "$todo" = '2' ]]; then
            read -p "Enter Channel Playlist URL: " channelplaylisturl
            curl $channelplaylisturl > /tmp/page
            sed -n 's/.*href="\([^"]*\).*/\1/p' /tmp/page | grep "?list" | cut -d"=" -f2 | sort -u > /tmp/list
            videofilename="%(playlist_uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"
            yesplaylist="--yes-playlist"
      fi
      if [[ "$todo" = '3' ]]; then
            read -p "Enter video URL: " videourl
            echo $videourl | cut -d"=" -f2 >> /tmp/list
            videofilename="%(uploader)s/%(title)s.%(ext)s"
            yesplaylist=""
      fi
for x in seq 1 2 ; do
youtube-dl $yesplaylist -r 8192k -o $videofilename --download-archive "$archivenamenonespace.downloaded.txt" --ignore-errors --batch-file /tmp/list
done
yesplaylist=""
cd ..
tar -czvf $archivenamenonespace.tar.gz $archivenamenonespace/* $archivenamenonespace.downloaded.txt --remove-files
rm -r $archivenamenonespace
rm -f  /tmp/list
rm -f  /tmp/page
