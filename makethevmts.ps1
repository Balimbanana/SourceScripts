# Written by: Balimbanana
# This is for automatically creating vmt's for all the vtf's in the current directory.
# Mainly used for map images for Mod Support's.
$a = @()
$il = ls "*.vtf" | % { [IO.Path]::GetFileNameWithoutExtension($_) }
$a = $il
for ($i = 0; $i -lt $a.Length; $i++){
    $path = $a[$i]
    echo "`"UnlitGeneric`"" > "$path.vmt"
    echo "{" >> "$path.vmt"
    echo "	`"`$basetexture`" `"vgui\maps\$path`"" >> "$path.vmt"
    echo "	`"`$translucent`" 1" >> "$path.vmt"
    echo "	`"`$ignorez`" 1" >> "$path.vmt"
    echo "	`"`$vertexcolor`" 1" >> "$path.vmt"
    echo "	`"`$vertexalpha`" 1" >> "$path.vmt"
    echo "}" >> "$path.vmt"
}
