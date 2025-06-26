extends Node2D

signal level_data_ready(highscore, attempts)

var level_name := "TestLevel"
var highscore := -1.0  # default: no score set yet
var attempts := 0

var highscore_achieved := false

const SAVE_PATH := "user://level_data.json"

func _ready():
	var level_data := _load_level_data()
	highscore = float(level_data.get("highscore", -1.0))
	attempts = int(level_data.get("attempts", 0))

	$gameManager.connect("reload_scene", self, "_reload_scene")
	$player.connect("reload_scene", self, "_reload_scene")
	
	emit_signal("level_data_ready", highscore, attempts)

func _reload_scene(time_of_last_goal):
	highscore_achieved = false
	attempts += 1
	_save_level_data(time_of_last_goal, attempts)
	
	if highscore_achieved == false:
		get_tree().reload_current_scene()

func _load_all_data() -> Dictionary:
	var file := File.new()
	if file.file_exists(SAVE_PATH):
		file.open(SAVE_PATH, File.READ)
		var raw := file.get_as_text()
		file.close()
		var parsed = parse_json(raw)
		if typeof(parsed) == TYPE_DICTIONARY:
			return parsed
	return {}

func _save_all_data(data: Dictionary):
	var file := File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_string(to_json(data))
	file.close()

func _load_level_data() -> Dictionary:
	var all_data := _load_all_data()
	var level_data = all_data.get(level_name, {})
	if typeof(level_data) != TYPE_DICTIONARY:
		level_data = {}
	return level_data

func _save_level_data(time_of_last_goal: float, attempts: int):
	var all_data := _load_all_data()
	var level_data = all_data.get(level_name, {})

	# Save new highscore only if better or not yet set
	if not level_data.has("highscore") or float(level_data["highscore"]) < 0 or time_of_last_goal < float(level_data["highscore"]):
		if time_of_last_goal > 0:
			level_data["highscore"] = time_of_last_goal
			highscore_achieved = true
			
	level_data["attempts"] = attempts
	all_data[level_name] = level_data
	_save_all_data(all_data)

	# Update local copy
	highscore = level_data["highscore"]
