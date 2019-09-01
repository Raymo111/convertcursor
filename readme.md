# Windows to Linux cursor converter

## Dependency
- ImageMagick

## Usage
`convertcursor [options]`

Option | Description
--- | ---
`-h` | Shows this help menu
`-v` | Be verbose, output more info (useful for debugging)
`-f [file]` | Convert a file
`-F [folder]` | Convert a folder
`-o [path]`| Output to directory (default is the original directory of the file) (make sure you omit the ending `/`)

Note: To convert multiple files or folders, simply use `-f` or `-F` multiple times, like so:
```
convertcursor -f file1 -f file2 -F folder1 -F folder2 -o /path/to/output/folder
```
