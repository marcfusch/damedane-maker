#!/bin/bash

input=$1

install(){
	echo "Checking install..."
	echo "You need to have the latest nvidia drivers that supports CUDA accleration"
	echo "Checking required libraires..."
	pip install -U -r requirements.txt
	echo "Checking ffmpeg..."
	sudo apt install ffmpeg
	echo "Install done !"
}

process(){
	if  python --version | grep -q 3. ; then
		python demo.py --config damedane-data/vox-adv-256.yaml --source_image $input --driving_video damedane-data/bakamitai_template.mp4 --checkpoint damedane-data/vox-adv-cpk.pth.tar --relative --adapt_scale
	elif python3 --version | grep -q 3. ; then
		python3 demo.py --config damedane-data/vox-adv-256.yaml --source_image $input --driving_video damedane-data/bakamitai_template.mp4 --checkpoint damedane-data/vox-adv-cpk.pth.tar --relative --adapt_scale
	else
		echo "Python not found. Please install it!"
	fi
}


if [[ $input == 'install' ]]; then
	install
elif [[ $input == '' ]]; then
	echo -e "Please specify an argument:\n Exemple: ./DAMEDANE.sh install\n Exemple: ./DAMEDANE.sh funnyface.jpg"
else
	if [[ ! -f "$input" ]]; then
		echo "${input} does not exists!"
		exit
	fi
	process
	echo "Adding audio"
	ffmpeg -i result.mp4 -i damedane-data/bakamitai_template.mp4 -c copy -map 0:v:0 -map 1:a:0 -shortest "$input.mp4"
	echo "Audio added!"
	rm result.mp4
	echo "Cleaning temp files..."
fi