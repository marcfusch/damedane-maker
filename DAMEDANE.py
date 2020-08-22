#!/usr/bin/python
# -*- coding: utf-8 -*-
#Python version: 3.7 or higher
print("Checking installation...")
import pkg_resources
from pkg_resources import DistributionNotFound, VersionConflict


requirements = open('requirements.txt', "r")
dependencies = requirements.readlines()
requirements.close()
pkg_resources.require(dependencies)

print("Install OK \nInitializing...")
from demo import load_checkpoints , make_animation
import imageio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from pyfiglet import Figlet
from skimage.transform import resize , img_as_ubyte
import warnings
import pkg_resources
from pkg_resources import DistributionNotFound, VersionConflict

"""
import subprocess
import sys
import os.path
from os import path
"""

print("#################################################")
print(Figlet().renderText('DameDaNe Standalone Maker'))
print("#################################################")
print("Original code and trained models by Aliaksandr Siarohin :\nhttps://github.com/AliaksandrSiarohin/first-order-model")


#####################


warnings.filterwarnings("ignore")

print("Importing files...")
source_image = imageio.imread('/damedane-data/source.jpg')
driving_video = imageio.mimread('damedane-data/bakamitai.mp4')

print("Resizing source file to target resolution [256x256]...")
source_image = resize(source_image, (256, 256))[..., :3]
driving_video = [resize(frame, (256, 256))[..., :3] for frame in driving_video]

def display(source, driving, generated=None):
    fig = plt.figure(figsize=(8 + 4 * (generated is not None), 6))

    ims = []
    for i in range(len(driving)):
        cols = [source]
        cols.append(driving[i])
        if generated is not None:
            cols.append(generated[i])
        im = plt.imshow(np.concatenate(cols, axis=1), animated=True)
        plt.axis('off')
        ims.append([im])

    ani = animation.ArtistAnimation(fig, ims, interval=33.33333, repeat_delay=1000)
    plt.close()
    return ani    


print("Generating keypoints...")
generator, kp_detector = load_checkpoints(config_path='config/vox-256.yaml', 
                            checkpoint_path='/damedane-data/models/vox-cpk.pth.tar')

print("Generating and exporting video...")
predictions = make_animation(source_image, driving_video, generator, kp_detector, relative=True)

imageio.mimsave('/damedane-data/generated.mp4', [img_as_ubyte(frame) for frame in predictions])


