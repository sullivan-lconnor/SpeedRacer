extends Control

onready var log_label := $Panel/Log
var log_messages := []

#const MAX_LOG_LINES := 10  # Optional limit

func _ready():
	$Panel/Log.text = ""
	var goals = get_tree().get_nodes_in_group("goal")
	for goal in goals:
		goal.connect("player_reached_goal", self, "_handle_goal")

	get_parent().connect("level_data_ready", self, "_on_level_data_ready")

func _on_level_data_ready(highscore, attempts):
	add_message("Highscore: %.2f sec   Attempts: %d" % [highscore, attempts])

	
func _handle_goal(time):
	var message = "Goal reached in: "
	add_message("%s (%.2f sec)" % [message, time])
			
func add_message(msg: String):
	log_messages.append(msg)
#	if log_messages.size() > MAX_LOG_LINES:
#		log_messages.pop_front()
	
	var log_message_string = ""
#	for msg in log_messages:
#		log_message_string += msg + "\n"
	if log_messages.size() > 1:
		log_message_string = log_messages[0] + "\n" + log_messages[-1]
	else:
		log_message_string = log_messages[0]
	$Panel/Log.text = log_message_string


