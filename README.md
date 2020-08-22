# DameDaNe Standalone Maker

This repository not only contains the source code for the First Order Motion Model by https://github.com/AliaksandrSiarohin/ but also some required data models and videos as well as a convinient script aimed at making DameDaNe deepfakes memes quick and easy.

## Before continuing

Note that the original motion model program uses CUDA acceleration on NVIDIA gpus only. You will be required to install the latest nvidia drivers with CUDA support.
If you do have an NVIDIA gpus however, you can continue by cloning the repo:
```
git clone https://github.com/marcfusch/damedane-standalone-maker/
cd damedane-standalone-maker/
```
## Installation

The original code supports ```python3``` and ```python2.7```. To launch the install process, run:
```
chmod 755 DAMEDANE.sh
./DAMEDANE.sh install
```
You can still do the installation process manually by running:
```
pip install -U -r requirements.txt
apt get install ffmpeg
```
Packet installation have also been tested with the ```--use-feature=2020-resolver``` feature.

## Making the meme

In order to make the meme, simply type:
```
./DAMEDANE.sh <image.jpg/png>
```
It will check if the picture exists and the correct python version to use.
After the motion model program finishes, ffmpeg will merge the audio track with the processed video.
The result will be exported at ```<image.jpg>.mp4```
