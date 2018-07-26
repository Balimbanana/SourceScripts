# Written by: Balimbanana
# NOTE: This will delete all files in the current directory and sub-directories after they have been converted to .bz2's.
# This is to be used for complete mods.
# Make a copy of all the required files and maps, and place in a separate directory, then CD to it and run this.
# Then simply move this directory to your FastDL server,
# and copy over the new .res files for said maps from the current directory to your servers maps directory.
$resfi = "dontdeletethis.res"
$a = @()
$il = ls -name -recurse
$a = $il
$endmapsres = @()

echo "`"resources`"" | Out-File -FilePath $resfi
echo "{" | Out-File -FilePath $resfi -Append
for ($i = 0; $i -lt $a.Length; $i++){
    $path = $a[$i]
    if (($path -like '*.*') -and ($path -notlike '*.bz2*') -and ($path -notlike '*.ztmp*') -and ($path -notlike '*.res*')) {
        $path
        start-process "C:\Program Files\7-Zip\7z.exe" "a -tbzip2 -mx=9 -mmt=2 `"$path.bz2`" `"$path`"" -wait -windowstyle hidden
        if ($path -notlike '*.bsp*') {
            if ($path -like '*\*') {
                $path = $path.Replace("\","/")
            }
            echo "	`"$path`" `"file`"" | Out-File -FilePath $resfi -Append
        } elseif ($path -notlike '*back*') {
            $pathedt = $path
            $pathedt = $pathedt.Replace("maps\","")
            $pathedt = $pathedt.Replace(".bsp","")
            echo "Will create .res for $pathedt"
            $endmapsres += $pathedt
        }
        rm $path
    }
}
echo "}" | Out-File -FilePath $resfi -Append

if ($endmapsres.Length -gt 0) {
    $b = cat $resfi
    for ($i = 0; $i -lt $endmapsres.Length; $i++){
        $path = $endmapsres[$i]
        for ($j = 0; $j -lt $b.Length; $j++){
        $tmp = $b[$j]
        echo "$tmp" | Out-File -FilePath "$path.res" -Append}
    }
    rm $resfi
}
