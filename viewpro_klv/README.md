# Prototype script for decoding KLV data from ViewPro IP cameras

```
└─$ ffplay udp://127.0.0.1:37777
└─$ ffmpeg -i video_from_ViewPro_camera_with_KLV.mp4 -map 0 -c copy -f mpegts "udp://127.0.0.1:37777" -map d -codec copy -f data - | xxd -p | ./extract.sh
```

```
# Extract KLV from video
└─$ ffmpeg -i video_from_ViewPro_camera_with_KLV.mp4 -map d -codec copy -f data KLV_from_ViewPro_camera.bin
└─$ cat KLV_from_ViewPro_camera.bin | xxd -p | ./extract.sh
```

## References:
- [Viewpro Tracking Series Gimbal Camera - Ethernet Encoding Meta Data Instruction](http://www.viewprotech.com/upfile/2022/11/20221121201032_340.pdf)
- [MISB_Standard_0601.pdf](https://upload.wikimedia.org/wikipedia/commons/1/19/MISB_Standard_0601.pdf)
- [MISB 0601 supported keys](https://www.impleotv.com/content/klvinspector/help/page_supported_keys.html)

## Tested on:
- [VQ40TPRO](http://www.viewprotech.com/index.php?ac=article&at=read&did=517)

## ToDo:
- Checksum Checker (to skip invalid messages)
- Rewrite to python
