# Written by: Balimbanana
# This script is used to reverse all BZ2's in the current and sub-directories back to regular files.
function setupvars()
{
    #Step size is how many will be extracted at once, then stop for steptime
    $stepsize = 10
    #Step time is how many seconds to wait after stepsize has been completed
    $steptime = 2
    $a = @()
    $il = ls -name -recurse
    $a = $il
    $completed = 0
    startscr
}

function startscr()
{
    for ($i = 0; $i -lt $a.Length; $i++){
        $path = $a[$i]
        if ($completed -ge $stepsize) {
            Start-Sleep -Seconds $steptime
            $completed = 0
        }
        if ($path -like '*.bz2*') {
            passpaths($path)
            $completed++
        }
    }
    for ($i = 0; $i -lt $a.Length; $i++){
        $path = $a[$i]
        if ($path -like '*.bz2*') {
            rm $path
        }
    }
}

function passpaths($pathpassed)
{
    write-host $pathpassed
    $fpos = $pathpassed.lastIndexOf("\")
    $afpos = $pathpassed.Substring(0,$fpos)
    start-process "C:\Program Files\7-Zip\7z.exe" "x -y `"$pathpassed`" -o`"$afpos`"" -windowstyle hidden
}
setupvars
