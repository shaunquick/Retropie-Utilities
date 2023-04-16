#! /bin/bash



# Ths scrip[t reformats video files so tha they can be read bbt emulatorstation
# when using steve selphs screenscraper software - the screenscraper website has 
# videos (mp4 files) that cannot be ready by either emaulatation nor windows.
# this utility takes every *.mp4 file from the source folder
# and check to see if it is in the correct format - if it is not then
# it will create a new copy of the video in a subfolder called ./newmp4
# You can then copy the reformmatted vidoes to where ever you need to.

#echo "started!"

# check to see if search folder was provided - if it was check it exists, if not then stop.

if (( ${#1} > 0 ));
then
	search_dir=$1
else
	search_dir='./video'
fi

if [ ! -d "$search_dir" ]; 
then
	echo "Directory $search_dir does not exist."
	echo "usage: reformatmp4s.sh [search_folder] [output_folder]"
	exit
fi

# check to see if output folder was provided - if it was check it exists
# if no folder provided - default this to the subfolder of the search directory and create it if it does not exist.
if (( ${#2} > 0 ));
then
	reformatted_mp4_dir=$2
	if [ ! -d "$reformatted_mp4_dir" ]; 
	then
		echo "Output Directory $reformatted_mp4_dir does not exist."
		exit
	fi

else
	reformatted_mp4_dir=$search_dir/reformatted_mp4
	# now create the output folder if it does not exists
	mkdir -p $reformatted_mp4_dir
fi





for entry in $search_dir/*.mp4;
do

	c=$(ffprobe $entry 2>&1 | grep -c yuv420p)

	if [ "$c" -eq 0 ]
	then
        echo Incorrect source video format detected for $entry. Converting video to 420p format...
#		echo $(basename $entry)
		ffmpeg -i $entry -y -c:v libx264 -pix_fmt yuv420p -acodec copy $reformatted_mp4_dir/$(basename $entry)
		#mmmmm="ffmpeg -i $entry -y -c:v libx264 -pix_fmt yuv420p -acodec copy $reformatted_mp4_dir/$(basename $entry)"
		#echo $mmmmm
        #ffmpeg -i "$1" -y -c:v libx264 -pix_fmt yuv420p -acodec copy "$2"
	else
        echo Video $entry is in correct 420p format. Nothing to do...
	fi

#	echo $(basename $entry)#
#	mmmmm="ffmpeg -i $entry -y -c:v libx264 -pix_fmt yuv420p -acodec copy $search_dir/newmp4/$(basename $entry)"
#	echo $mmmmm
done