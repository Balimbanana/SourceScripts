# Written by: Balimbanana
# This script renames all files named toreplace* to whichever you define. A simple script.
$first = "toreplace*"
$second = "replaced"
ls $first | rename-item -newname { $_.name -replace $first, $second }
