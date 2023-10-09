(1) Build FFmpeg
git clone git@github.com:FFmpeg/FFmpeg.git
cd FFmpeg
git checkout release/0.6
git apply ../ffmpeg_qbox.patch
./configure --disable-ffserver --enable-libx264 --enable-gpl
make
cd ..

(2) Build ojd to qbox converter
gcc ojd_to_qbx.c -o ojd_to_qbx
chmod +x ./ojd_to_qbx

(3) Convert!
./ojd_to_qbx aqboxp video.ojd
./FFmpeg/ffmpeg -i video.qbx -vcodec copy -acodec copy video.mp4

(4) Hallelujah!
