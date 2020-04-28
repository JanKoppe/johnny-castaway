#!/bin/bash
# remove artefacts from previous runs that might stop startup
rm -rf /root/.config/pulse/* /tmp/* /tmp/.* || true

# start fresh pulseaudio server with virtual output device
pulseaudio -D --exit-idle-time=-1
pactl load-module module-null-sink sink_name=SpeakerOutput sink_properties=device.description="Dummy_Output"

# start dosbox in a virtual framebuffer
xvfb-run --listen-tcp --server-num 42 --auth-file /tmp/xvfb.auth -s " -ac -screen 0 640x480x24" -e /dev/stdout -a $(which dosbox) &

# grab audio and framebuffer, encode, push \o/
ffmpeg -loglevel warning -f pulse -i default -f x11grab -draw_mouse 0 -s 640x480 -i :42 -pix_fmt yuv420p -c:a aac -c:v libx264 -profile:v baseline -preset slow -g 30 -movflags +faststart -f flv ${RTMP_TARGET}
