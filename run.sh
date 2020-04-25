#!/bin/bash
pulseaudio -D --exit-idle-time=-1
pactl load-module module-null-sink sink_name=SpeakerOutput sink_properties=device.description="Dummy_Output"
xvfb-run --listen-tcp --server-num 42 --auth-file /tmp/xvfb.auth -s " -ac -screen 0 640x480x24" -e /dev/stdout -a $(which dosbox) &
ffmpeg -loglevel warning -f pulse -i default -f x11grab -draw_mouse 0 -s 640x480 -i :42 -pix_fmt yuv420p -c:a aac -c:v libx264 -profile:v baseline -preset slow -g 30 -movflags +faststart -f flv ${RTMP_TARGET}
