#!/bin/bash

input=$1
memelocation='damedane-data/bakamitai_template.mp4'
install(){
	echo -e "Checking install..."
	echo -e "You NEED to have the latest nvidia drivers that supports CUDA accleration"
	echo -e "Checking required libraires...\n"
	pip install -U -r requirements.txt
	echo -e "\nChecking ffmpeg...\n"
	sudo apt install ffmpeg
	echo -e "\nRemember you still have to download this file: \e[31;4mhttps://drive.google.com/uc?export=download&id=1L8P-hpBhZi8Q_1vP2KlQ4N6dvlzpYBvZ\n\e[39;24mAfter that, put it in the damedane-data/ directory."
	echo -e "\e[1mInstall done !"
}

process(){
	if  python --version | grep -q 3. ; then
		python demo.py --config damedane-data/vox-adv-256.yaml --source_image $input --driving_video $memelocation --checkpoint damedane-data/vox-adv-cpk.pth.tar --relative --adapt_scale
	elif python3 --version | grep -q 3. ; then
		python3 demo.py --config damedane-data/vox-adv-256.yaml --source_image $input --driving_video $memelocation --checkpoint damedane-data/vox-adv-cpk.pth.tar --relative --adapt_scale
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
	if [[ ! -f damedane-data/vox-adv-cpk.pth.tar ]]; then
		echo -e "Checkpoint data file not found.\nPlease ensure the file located here: damedane-data/vox-adv-cpk.pth.tar"
		exit
	fi
	process
	echo "Adding audio"
	ffmpeg -i result.mp4 -i $memelocation -c copy -map 0:0 -map 1:1 -shortest "$input.mp4"
	echo -e "Audio added!\nCleaning up temp files..."
	rm result.mp4
	echo -e "\e[1mDone !"
fi
