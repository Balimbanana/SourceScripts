# Written by: Balimbanana
# This script creates links from all the directories in the current directory and places links in $linksfrom
# Creates the links in $linksfrom
$a = @()
$linksto = "$PWD"
$linksfrom = "E:\rondom\ps\tst"
$il = ls -Directory -Name
$a = $il
for ($i = 0; $i -lt $a.Length; $i++){
    $path = $a[$i]
    if (!(Test-Path $linksfrom\$path)) {
        write-host "Link from: $linksfrom\$path to $linksto\$path"
        cmd /c mklink /d "$linksfrom\$path" "$linksto\$path" | Out-Null
    }
}
# You can change the above /d to a /j for junctions if needed.
