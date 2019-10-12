# Written by: Balimbanana
# This is used to create a template .edt of all maps in the current directory.
# This template is for DM ported maps with info_player_rebel info_player_combine and respawning weapon pickups
$a = @()
$il = ls "*.bsp" | % { [IO.Path]::GetFileNameWithoutExtension($_) }
$a = $il
for ($i = 0; $i -lt $a.Length; $i++){
    $path = $a[$i]
    if ($a -isnot [array]) {
        $path = $a
    }
    if (!(Test-Path "$path.edt")) {
        echo "`"$path`"" > "$path.edt"
        echo "{" >> "$path.edt"
        echo "	console" >> "$path.edt"
        echo "	{" >> "$path.edt"
        echo "		mp_reset `"0`"" >> "$path.edt"
        echo "		mp_weaponstay `"1`"" >> "$path.edt"
        echo "	}" >> "$path.edt"
        echo "	entity" >> "$path.edt"
        echo "	{" >> "$path.edt"
        echo "		delete {classname `"item_suit`"}" >> "$path.edt"
        echo "		create {classname `"info_player_equip`"" >> "$path.edt"
        echo "			values" >> "$path.edt"
        echo "			{" >> "$path.edt"
        echo "				item_suit `"1`"" >> "$path.edt"
        echo "				item_armor `"45`"" >> "$path.edt"
        echo "				weapon_physcannon `"1`"" >> "$path.edt"
        echo "				weapon_crowbar `"1`"" >> "$path.edt"
        echo "				weapon_pistol `"1`"" >> "$path.edt"
        echo "					ammo_pistol `"54`"" >> "$path.edt"
        echo "				weapon_357 `"1`"" >> "$path.edt"
        echo "					ammo_357 `"6`"" >> "$path.edt"
        echo "				weapon_smg1 `"1`"" >> "$path.edt"
        echo "					ammo_smg1 `"45`"" >> "$path.edt"
        echo "				weapon_ar2 `"1`"" >> "$path.edt"
        echo "					ammo_ar2 `"60`"" >> "$path.edt"
        echo "				weapon_shotgun `"1`"" >> "$path.edt"
        echo "					ammo_buckshot `"6`"" >> "$path.edt"
        echo "				weapon_crossbow `"1`"" >> "$path.edt"
        echo "					ammo_xbowbolt `"6`"" >> "$path.edt"
        echo "				weapon_frag `"1`"" >> "$path.edt"
        echo "			}" >> "$path.edt"
        echo "		}" >> "$path.edt"
#        echo "		edit {classname `"game_text`" values {spawnflags `"1`"} }" >> "$path.edt"
        echo "		create {classname `"logic_auto`"" >> "$path.edt"
        echo "			values" >> "$path.edt"
        echo "			{" >> "$path.edt"
        echo "				spawnflags `"1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_*,AddOutput,RespawnCount -1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"item_*,AddOutput,RespawnCount -1,0,-1`"" >> "$path.edt"
        echo "			}" >> "$path.edt"
        echo "		}" >> "$path.edt"
        echo "		delete {classname `"point_clientcommand`"}" >> "$path.edt"
        echo "		delete {classname `"point_servercommand`"}" >> "$path.edt"
        echo "		edit {classname `"info_player_rebel`" values {classname `"info_player_coop`"} }" >> "$path.edt"
        echo "		edit {classname `"info_player_deathmatch`" values {classname `"info_player_coop`"} }" >> "$path.edt"
        echo "		edit {classname `"ai_relationship`" values {Reciprocal `"1`"} }" >> "$path.edt"
        echo "		create {classname `"info_global_settings`" values {IsVehicleMap `"1`"} }" >> "$path.edt"
        echo "	}" >> "$path.edt"
        echo "}" >> "$path.edt"
    }
}
