#!/bin/sh

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

flag=0
o=0
scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
verbose=0

show_help () {
	echo -e "Welcome to convertcursor, which helps you convert your Windows cursors to Linux.\n
				ImageMagick is the only required dependency.\n
				To use this program, do:\nconvertcursor [options]\n
				The options are as follows:\n
				-h\t\tShows this help menu\n
				-v\t\tBe verbose, output more info (useful for debugging)\n
				-o [path]\tOutput to directory (default is the original directory of the file) (make sure you omit the ending '/')\n
				-f [file]\tConvert a file\n
				-F [folder]\tConvert a folder\n
				Note: To convert multiple files or folders, simply use -f or -F multiple times, like so:\n
				convertcursor -f file1 -f file2 -F folder1 -F folder2 -o /path/to/output/folder\n
				Bugs I can't fix:\n
				 - Make sure you use full paths, starting with '/'. Don't do '~/file', do '/home/<username>/file'
				 - Use '-v' first, then '-o', then '-f' and/or '-F'
				 If you don't like these restrictions then feel free to submit a PR fixing it.
				 #### Final note: DO NOT RUN THIS PROGRAM WITH `SUDO`. I AM NOT RESPONSIBLE FOR ANYTHING BAD THAT HAPPENS TO YOUR COMPUTER WHEN USING THIS PROGRAM. ####
			"
}

while getopts ":hvf:F:o:" opt; do
	case $opt in
	h)
		show_help
		exit 0
		;;
	v)	verbose=1
		;;
	f)
		indir=$(dirname "$OPTARG")
		if [ $o == 0 ]; then outdir=$indir; fi
		if [ ${OPTARG: -4} == ".cur" ]
		then
			if [ $verbose == 1 ]; then echo -e "Performing convert operation on file: $OPTARG\nIndir: $indir\nOutdir: $outdir\nScript path: $scriptpath"; fi
			name=$(basename "$OPTARG" .cur)
			if [ $verbose == 1 ]; then echo "Name of file: $name"; fi
			mkdir -p "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Made directory: $outdir/$name"; fi
			cd "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Entered directory: $outdir/$name"; fi
			cp "$indir/$name.cur" .
			if [ $verbose == 1 ]; then echo "Copied $indir/$name.cur"; fi
			convert "$name.cur" "file.png"
			if [ $verbose == 1 ]; then echo "Converted to png"; fi
			identify -format '%w 1 1 %f\n' "file.png" >> "file.xcg"
			if [ $verbose == 1 ]; then echo "xcg created"; fi
			xcursorgen "file.xcg" "$name"
			if [ $verbose == 1 ]; then echo "Cursor generated"; fi
			find . ! -name "$name" -type f -exec rm -f {} +
			if [ $verbose == 1 ]; then echo "Removed intermediary files"; fi
		elif [ ${OPTARG: -4} == ".ani" ]
		then
			if [ $verbose == 1 ]; then echo -e "Performing convert operation on file: $OPTARG\nIndir: $indir\nOutdir: $outdir\nScript path: $scriptpath"; fi
			name=$(basename "$OPTARG" .ani)
			if [ $verbose == 1 ]; then echo "Name of file: $name"; fi
			mkdir -p "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Made directory: $outdir/$name"; fi
			cd "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Entered directory: $outdir/$name"; fi
			cp "$indir/$name.ani" file.ani
			if [ $verbose == 1 ]; then echo "Copied $indir/$name.ani"; fi
			"$scriptpath/ani2ico/ani2ico" "file.ani"
			if [ $verbose == 1 ]; then echo "Converted ani to ico's"; fi
			for f in "file*.ico"; do
				filename=$(basename "$f")
				png="${filename%.*}".png
				convert "$f" "$png"
				if [ $verbose == 1 ]; then echo "Converted to png"; fi
				identify -format '%w 1 1 %f 200\n' "$png" >> "file.xcg"
				if [ $verbose == 1 ]; then echo "xcg created"; fi
			done
			xcursorgen "file.xcg" "$name"
			if [ $verbose == 1 ]; then echo "Cursor generated"; fi
			find . ! -name "$name" -type f -exec rm -f {} +
			if [ $verbose == 1 ]; then echo "Removed intermediary files"; fi
		else
			echo "$OPTARG is an invalid file. It must have a .cur or .ani extension." >&2
		fi
		flag=1
		;;
	F)
		dir=$(sed 's/ /\\ /g' <<< "$OPTARG")
		if [ $verbose == 1 ]; then echo "Performing convert operation on folder: $dir"; fi
		for name in $dir/*.cur; do
			indir=$(dirname "$name")
			if [ $o == 0 ]; then outdir=$indir; fi
			if [ $verbose == 1 ]; then echo -e "Indir: $indir\nOutdir: $outdir\nScript path: $scriptpath"; fi
			name=$(basename "$name" .cur)
			if [ $verbose == 1 ]; then echo "Name of file: $name"; fi
			mkdir -p "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Made directory: $outdir/$name"; fi
			cd "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Entered directory: $outdir/$name"; fi
			cp "$indir/$name.cur" .
			if [ $verbose == 1 ]; then echo "Copied $indir/$name.cur"; fi
			convert "$name.cur" "file.png"
			if [ $verbose == 1 ]; then echo "Converted to png"; fi
			identify -format '%w 1 1 %f\n' "file.png" >> "file.xcg"
			if [ $verbose == 1 ]; then echo "xcg created"; fi
			xcursorgen "file.xcg" "$name"
			if [ $verbose == 1 ]; then echo "Cursor generated"; fi
			find . ! -name "$name" -type f -exec rm -f {} +
			if [ $verbose == 1 ]; then echo "Removed intermediary files"; fi
		done
		for name in $dir/*.ani; do
			indir=$(dirname "$name")
			if [ $o == 0 ]; then outdir=$indir; fi
			if [ $verbose == 1 ]; then echo -e "Indir: $indir\nOutdir: $outdir\nScript path: $scriptpath"; fi
			name=$(basename "$name" .ani)
			if [ $verbose == 1 ]; then echo "Name of file: $name"; fi
			mkdir -p "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Made directory: $outdir/$name"; fi
			cd "$outdir/$name"
			if [ $verbose == 1 ]; then echo "Entered directory: $outdir/$name"; fi
			cp "$indir/$name.ani" file.ani
			if [ $verbose == 1 ]; then echo "Copied $indir/$name.ani"; fi
			"$scriptpath/ani2ico/ani2ico" "file.ani"
			if [ $verbose == 1 ]; then echo "Converted ani to ico's"; fi
			for f in "file*.ico"; do
				filename=$(basename "$f")
				png="${filename%.*}".png
				convert "$f" "$png"
				if [ $verbose == 1 ]; then echo "Converted to png"; fi
				identify -format '%w 1 1 %f 200\n' "$png" >> "file.xcg"
				if [ $verbose == 1 ]; then echo "xcg created"; fi
			done
			xcursorgen "file.xcg" "$name"
			if [ $verbose == 1 ]; then echo "Cursor generated"; fi
			find . ! -name "$name" -type f -exec rm -f {} +
			if [ $verbose == 1 ]; then echo "Removed intermediary files"; fi
		done
		flag=1
		;;
	o)
		o=1
		outdir=$OPTARG
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		show_help
		exit 1
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		show_help
		exit 1
		;;
	esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift
