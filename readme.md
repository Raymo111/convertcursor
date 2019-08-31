# Windows to Linux cursor converter

## Dependency
- ImageMagick

## Usage
`convertcursor [options]`

Option | Description
--- | ---
`-h` | Shows this help menu
`-f path` | Convert a file
`-F path` | Convert a folder
`-o path`| Output to directory (default is the original directory of the file) (make sure you end with a `/`)
Note: To convert multiple files or folders, simply use `-f` or `-F` multiple times, like so:
```
convertcursor -f file1 -f file2 -F folder1 -F folder2 -o /path/to/output/
```
