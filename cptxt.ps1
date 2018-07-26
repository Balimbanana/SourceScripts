# Written by: Balimbanana
# This script is to take a res file and copy out all the files it lists from a mod and place in the $tocp directory.
# Useful when mods contain a whole lot of files you don't need, and have a .res file that has the specific files you want.
$tocp = "modredux"
$a = @()
$il = cat ..\$tocp\mapname.res
$a = $il
for ($i = 0; $i -lt $a.Length; $i++){
    $path = $a[$i]
    $path = $path.Trim()
    if ($path -like '*/*') {
        $path = $path.Replace("/","\")
    }
    if (($path -like '*.*') -and ($path -notlike '*.bz2*') -and ($path -notlike '*{*') -and ($path -notlike '*}*')) {
        write-host "$PWD\$path to ..\$tocp\$path"
        if (Test-Path($path)){
            new-item -itemtype file -Force ..\$tocp\$path
            copy-item "$path" -Force -Destination ..\$tocp\$path
        } else {
            write-host "$path did not exist"
            $path>>cptxterr.txt
        }
    }
}
