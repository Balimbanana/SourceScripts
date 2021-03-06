# Written by: Balimbanana
# This is used to create a template .edt of all maps in the current directory.
# This template is for a starting point of single-player campaign maps
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
        echo "	entity" >> "$path.edt"
        echo "	{" >> "$path.edt"
        echo "		delete {classname `"item_suit`"}" >> "$path.edt"
        echo "		create {classname `"info_player_equip`"" >> "$path.edt"
        echo "			values" >> "$path.edt"
        echo "			{" >> "$path.edt"
        echo "				item_suit `"1`"" >> "$path.edt"
        echo "				item_armor `"45`"" >> "$path.edt"
        echo "			}" >> "$path.edt"
        echo "		}" >> "$path.edt"
        echo "		edit {classname `"game_text`" values {spawnflags `"1`"} }" >> "$path.edt"
        echo "		edit {classname `"func_areaportal`" values {targetname `"disabledPortal`" StartOpen `"1`"} }" >> "$path.edt"
        echo "		edit {classname `"point_viewcontrol`" values {edt_addedspawnflags `"128`"} }" >> "$path.edt"
        echo "		create {classname `"logic_auto`"" >> "$path.edt"
        echo "			values" >> "$path.edt"
        echo "			{" >> "$path.edt"
        echo "				spawnflags `"1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_crowbar,AddOutput,OnPlayerPickup cpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_crowbar,AddOutput,OnPlayerPickup cpickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_pistol,AddOutput,OnPlayerPickup ppickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_pistol,AddOutput,OnPlayerPickup ppickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_357,AddOutput,OnPlayerPickup rpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_357,AddOutput,OnPlayerPickup rpickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_smg1,AddOutput,OnPlayerPickup smgpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_smg1,AddOutput,OnPlayerPickup smgpickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_ar2,AddOutput,OnPlayerPickup ar2pickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_ar2,AddOutput,OnPlayerPickup ar2pickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_shotgun,AddOutput,OnPlayerPickup bpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_shotgun,AddOutput,OnPlayerPickup bpickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_crossbow,AddOutput,OnPlayerPickup xpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_crossbow,AddOutput,OnPlayerPickup xpickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_frag,AddOutput,OnPlayerPickup fragpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_rpg,AddOutput,OnPlayerPickup rpgpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_rpg,AddOutput,OnPlayerPickup rpgpickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_physcannon,AddOutput,OnPlayerPickup gpgpickup:Enable::0:-1,0,-1`"" >> "$path.edt"
        echo "				OnMapSpawn `"weapon_physcannon,AddOutput,OnPlayerPickup gpgpickup:EquipAllPlayers::0.1:-1,0,-1`"" >> "$path.edt"
        echo "			}" >> "$path.edt"
        echo "		}" >> "$path.edt"
        echo "		delete {classname `"point_clientcommand`"}" >> "$path.edt"
        echo "		delete {classname `"point_servercommand`"}" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"cpickup`" startdisabled `"1`" weapon_crowbar `"1`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"ppickup`" startdisabled `"1`" weapon_pistol `"1`" ammo_pistol `"18`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"rpickup`" startdisabled `"1`" weapon_357 `"1`" ammo_357 `"6`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"smgpickup`" startdisabled `"1`" weapon_smg1 `"1`" ammo_smg1 `"45`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"ar2pickup`" startdisabled `"1`" weapon_ar2 `"1`" ammo_ar2 `"30`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"bpickup`" startdisabled `"1`" weapon_shotgun `"1`" ammo_buckshot `"12`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"xpickup`" startdisabled `"1`" weapon_crossbow `"1`" ammo_xbowbolt `"5`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"fragpickup`" startdisabled `"1`" weapon_frag `"1`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"rpgpickup`" startdisabled `"1`" weapon_rpg `"1`" ammo_rpg_round `"2`"} }" >> "$path.edt"
        echo "		create {classname `"info_player_equip`" values {targetname `"gpickup`" startdisabled `"1`" weapon_physcannon `"1`"} }" >> "$path.edt"
        echo "	}" >> "$path.edt"
        echo "}" >> "$path.edt"
    }
}
