#!/bin/bash
randomdir=$RANDOM
mkdir $randomdir
cd $randomdir
read -p "PLAYLIST(1) OR CHANNEL(2)? [1/2]: " -e -i 2 todo
      if [[ "$todo" = '2' ]]; then
            read -p "Enter Playlist URL: " playlisturl
            videofilename="%(playlist_uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"
      fi
      if [[ "$todo" = '2' ]]; then
            read -p "Enter Channel Playlist URL: " channelplaylisturl
            curl $channelplaylisturl > /tmp/page
            sed -n 's/.*href="\([^"]*\).*/\1/p' /tmp/page | grep "?list" | cut -d"=" -f2 | sort -u > /tmp/list
            videofilename="%(playlist_uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"
      fi
youtube-dl --yes-playlist -r 4096k -o $videofilename --download-archive "../$randomdir.downloaded.txt" --ignore-errors --batch-file /tmp/list
youtube-dl --yes-playlist -r 4096k -o $videofilename --download-archive "../$randomdir.downloaded.txt" --ignore-errors --batch-file /tmp/list
ls > /tmp/ydlls
playlistuploadername=`cat /tmp/ydlls`
playlistuploadernamenonespace=`echo $playlistuploadername | tr ' ' '_'`
tar -czvf ../$playlistuploadernamenonespace.tar.gz * ../$randomdir.downloaded.txt --remove-files
cd ..
rm -r $randomdir
rm  /tmp/list
rm  /tmp/page
