#!/bin/sh

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

flag=0
indir=$(dirname "${VAR}")
outdir=$indir
scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"

show_help () {
	echo -e "Welcome to convertcursor, which helps you convert your Windows cursors to Linux.\nImageMagick is the only required dependency.\nTo use this program, do:\nconvertcursor [options]\nThe options are as follows:\n-h\tShows this help menu\n-f [file]\tConvert a file\n-F [folder]\tConvert a folder
\n-o [path]\tOutput to directory (default is the original directory of the file) (make sure you omit the ending '/')\nNote: To convert multiple files or folders, simply use -f or -F multiple times, like so:\nconvertcursor -f file1 -f file2 -F folder1 -F folder2 -o /path/to/output/folder
}

while getopts ":hf:F:o:" opt; do
	case $opt in
	h)
		show_help
		exit 0
		;;
	f)
		if [ ${file: -4} == ".cur" ]
		then
			name=$(basename "$name" .cur)
			mkdir -p "$outdir/$name"
			cd "$outdir/$name"
			cp "$indir/$name.cur" .
			convert "$name.cur" "$name.png"
			identify -format '%w 1 1 %f\n' "$name.png" >> "$name.xcg"
			xcursorgen "$name.xcg" "$name"
		elif [ ${file: -4} == ".ani" ]
		then
			name=$(basename "$name" .ani)
			mkdir -p "$outdir/$name"
			cd "$outdir/$name"
			cp "$indir/$name.ani" .
			"scriptpath/ani2ico/ani2ico" "$name.ani"
			rm "$name.ani"
			for f in "$name*.ico"; do
				filename=$(basename "$f")
				png="${filename%.*}".png
				convert "$f" "$png"
				identify -format '%w 1 1 %f 200\n' "$png" >> "$name.xcg"
			done
			xcursorgen "$name.xcg" "$name"
		else
			echo "$OPTARG is an invalid file. It must have a .cur or .ani extension." >&2
		fi
		flag=1
		;;
	F)
		for name in "$indir/*.cur"; do
			name=$(basename "$name" .cur)
			mkdir -p "$outdir/$name"
			cd "$outdir/$name"
			cp "$indir/$name.cur" .
			convert "$name.cur" "$name.png"
			identify -format '%w 1 1 %f\n' "$name.png" >> "$name.xcg"
			xcursorgen "$name.xcg" "$name"
		done
		for name in "$indir/*.ani"; do
			name=$(basename "$name" .ani)
			mkdir -p "$outdir/$name"
			cd "$outdir/$name"
			cp "$indir/$name.ani" .
			"scriptpath/ani2ico/ani2ico" "$name.ani"
			rm "$name.ani"
			for f in "$name*.ico"; do
				filename=$(basename "$f")
				png="${filename%.*}".png
				convert "$f" "$png"
				identify -format '%w 1 1 %f 200\n' "$png" >> "$name.xcg"
			done
			xcursorgen "$name.xcg" "$name"
		done
		flag=1
		;;
	o)
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
