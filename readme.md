# Windows to Linux cursor converter

## Dependency
- ImageMagick

## Usage
`convertcursor [options]`

Option | Description
--- | ---
`-h` | Shows this help menu
`-v` | Be verbose, output more info (useful for debugging)
`-o [path]`| Output to directory (default is the original directory of the file) (make sure you omit the ending `/`)
`-f [file]` | Convert a file
`-F [folder]` | Convert a folder

Note: To convert multiple files or folders, simply use `-f` or `-F` multiple times, like so:
```
convertcursor -vo /path/to/output/folder -f file1 -f file2 -F folder1 -F folder2
```
Bugs I can't fix:
 - Make sure you use full paths, starting with `/`. Don't do `~/file`, do `/home/<username>/file`
 - Use `-v` first, then `-o`, then `-f` or `-F`
If you don't like these restrictions then feel free to submit a PR fixing it.

#### Final note: DO NOT RUN THIS PROGRAM WITH `SUDO`. I AM NOT RESPONSIBLE FOR ANYTHING BAD THAT HAPPENS TO YOUR COMPUTER WHEN USING THIS PROGRAM.
