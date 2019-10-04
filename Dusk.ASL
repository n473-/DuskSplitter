//Special thanks to Psych0sis and CptBrian

state("Dusk", "Steam") 
{
	byte Level: "mono-2.0-bdwgc.dll", 0x04A32A0, 0x280, 0x110, 0x30, 0xA0, 0x60, 0xDC;
	float StatsScreenTimeSeconds: "mono-2.0-bdwgc.dll", 0x04A3318, 0x2A8, 0x280, 0x110, 0x30, 0xA0, 0x60, 0xA8;
	float StatsScreenTimeMinutes: "mono-2.0-bdwgc.dll", 0x04A3318, 0x2A8, 0x280, 0x110, 0x30, 0xA0, 0x60, 0xA4;
}

state("Dusk", "GOG") 
{
	byte Level: "mono-2.0-bdwgc.dll", 0x0489A90, 0xB28, 0x10, 0xD0, 0x28, 0xDC;
	float StatsScreenTimeSeconds: "mono-2.0-bdwgc.dll", 0x0489A90, 0xB28, 0xA8;
	float StatsScreenTimeMinutes: "mono-2.0-bdwgc.dll", 0x0489A90, 0xB28, 0x10, 0x100, 0x28, 0xA4;
}

startup 
{
	settings.Add("Fullgame", false, "Every Episode starting from E1M1");
	settings.Add("GOG", false, "Select if using GOG version");
}

init 
{
	if (settings["GOG"] && version != "GOG") {
		version = "GOG";
	} else {
		version = "Steam";
	}

	refreshRate = 60;
	vars.IGT = 0;
	vars.SumIGTE1 = 0;
	vars.SumIGTE2 = 0;
}

update 
{
	current.IGT = current.StatsScreenTimeSeconds + (current.StatsScreenTimeMinutes * 60);
	
	if (current.Level == 13 && vars.SumIGTE1 != current.IGT) {
		vars.SumIGTE1 = current.IGT;
	}
	
	if (current.Level == 35 && vars.SumIGTE2 != current.IGT) {
		vars.SumIGTE2 = current.IGT;
	}
}

start 
{
	vars.SumIGTE1 = 0;
	vars.SumIGTE2 = 0;
	
	if (settings["Fullgame"]) {
		if (current.Level == 3 && old.Level == 21) {
			return true;
		}
	}
	
	else if (current.Level == 3 && old.Level == 21) {
		return true;
	}
	
	else if (current.Level == 22 && old.Level == 33) {
		return true;
	}

	else if (current.Level == 37 && old.Level == 48) {
		return true;
	}
	
}

split 
{
	if (settings["Fullgame"]) {
		if (current.Level > old.Level || (current.Level == 5 && old.Level == 14) || (current.Level == 26 && old.Level == 32) || (current.Level == 41 && old.Level == 47)) {
			if (current.Level != 21 && current.Level != 33 && current.Level != 48 && old.Level != 13 && old.Level != 35 && old.Level != 47){
				return true;
			}
		}
	}
	else if (current.Level > old.Level || (current.Level == 5 && old.Level == 14) || (current.Level == 26 && old.Level == 32) || (current.Level == 41 && old.Level == 47)) {
		if (current.Level != 21 && current.Level != 33 && current.Level != 48 && old.Level != 13 && old.Level != 35 && old.Level != 47){
			return true;
		}
	}
}

reset 
{
	if (settings["Fullgame"]){
		if (current.Level == 3 && old.Level == 21) {
			return true;
		}
	} else {
		if (current.Level == 3 && old.Level == 21) {
			return true;
		}
		else if (current.Level == 22 && old.Level == 33) {
			return true;
		}
		else if (current.Level == 37 && old.Level == 48) {
			return true;
		}
	}
}

gameTime 
{
	if (current.IGT != 0) {
		if (current.IGT > old.IGT) {
			if (current.IGT == vars.SumIGTE2) {
				return TimeSpan.FromSeconds (vars.SumIGTE2 + vars.SumIGTE1);
			} else if (current.IGT != vars.SumIGTE2 && current.IGT == vars.SumIGTE1) {
				return TimeSpan.FromSeconds (vars.SumIGTE1);
			} else {
				return TimeSpan.FromSeconds (current.IGT + vars.SumIGTE2 + vars.SumIGTE1);
			}
		}
	}
}

isLoading 
{
	return true;
}