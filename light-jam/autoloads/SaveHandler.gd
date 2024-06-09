extends Node

const CURRENT_GAME_VERSION: String = "1.0.0"

const SAVE_PATH: String = "user://save.cfg"
const USER_SECTION: String = "USER"

func check_compatibility(version: String) -> String:
	var upgraded_version: String = "1.0.0"
	
	match version:
		"NO SAVE":
			save_config()
			upgraded_version = CURRENT_GAME_VERSION
		CURRENT_GAME_VERSION:
			upgraded_version = CURRENT_GAME_VERSION
	
	return upgraded_version

func save_config() -> void:
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	
	config.set_value(USER_SECTION, "game_version", CURRENT_GAME_VERSION)
	
	config.set_value(USER_SECTION, "latest_score", Global.latest_score)
	config.set_value(USER_SECTION, "high_score", Global.high_score)
	
	config.save(SAVE_PATH)

func save_key(key: String, value: Variant) -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		return
	
	config.set_value(USER_SECTION, key, value)
	
	config.save(SAVE_PATH)

func load_config() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	var save_version: String = "1.0.0"
	
	if error != OK:
		save_version = "NO SAVE"
	else:
		save_version = config.get_value(USER_SECTION, "game_version")
	
	while save_version != CURRENT_GAME_VERSION: 
		save_version = await check_compatibility(save_version)
	
	error = config.load(SAVE_PATH)
	if error != OK:
		return
	
	Global.latest_score = config.get_value(USER_SECTION, "latest_score")
	Global.high_score = config.get_value(USER_SECTION, "high_score")
