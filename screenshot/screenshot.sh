#!/bin/bash

type=$1
dur=$2
if [ "$type" != "image" ]; then
	if [ "$type" != "video" ]; then
		type="image"
	fi
fi

# Server stuff goes here
server="user@server:/path/to/server/${type}s"
temp="/tmp"
url="http://domain.tld/${type}s"
imageEncoding=".png"
videoEncoding=".webm"
name=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8`
pidFile="/tmp/seen_record.pid"

if [ "$type" == "image" ]; then
	eval `slop --nokeyboard`
	if [ "$(($W+$H))" != "0" ]; then
		maim -g="${W}x${H}+${X}+${Y}" "${temp}/${name}${imageEncoding}"
		sftp "${server}" <<< "put "${temp}/${name}${imageEncoding}" "${name}${imageEncoding}""
		if [ $? -eq 0 ]; then
			notify-send '<b>Screenshot uploaded!</b>' "${url}/${name}${imageEncoding}"
		else
			error=$?
			notify-send "Screenshot upload failed" "Error ${error}"
		fi
		echo -n "${url}/${name}${imageEncoding}" | xclip -selection clipboard
	fi
else
	if [ -f "$pidFile" ]; then
		pid=`cat "$pidFile"`
		kill $pid
		sftp "${server}" <<< "put "${temp}/${name}${imageEncoding}" "${name}${imageEncoding}""
		if [ $? -eq 0 ]; then
			notify-send 'Video uploaded!'
		else
			notify-send 'Video upload failed' 'Error $?'
		fi
		echo -e "\a"
		rm "$pidFile"
		exit 0
	fi
	eval `slop --nokeyboard`
	if [ "$(($W+$H))" != "0" ]; then
		echo -e "\a"
		ffmpeg -f x11grab -s "${W}x${H}" -i ":0.0+${X},${Y}" -an "${temp}/${name}${videoEncoding}" &
		pid=$!
		echo -n "$pid" > /tmp/seen_record.pid
		echo -n "${url}/${name}${videoEncoding}" | xclip -selection clipboard
		sleep ${dur}
				pid=`cat "$pidFile"`
		kill $pid
		sftp "${server}" <<< "put "${temp}/${name}${videoEncoding}" "${name}${videoEncoding}""
		if [ $? -eq 0 ]; then
			notify-send 'Video uploaded!'
		else
			notify-send 'Video upload failed: Error $?'
		fi
		echo -e "\a"
		rm "$pidFile"
		exit 0
	fi
fi
