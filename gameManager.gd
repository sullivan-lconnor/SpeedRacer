extends Node2D

signal reload_scene(time_of_last_goal)

var total_goals := 0
var goals_reached := 0
var time_of_last_goal := 0.0

func _ready():
	var goals = get_tree().get_nodes_in_group("goal")
	total_goals = goals.size()
	
	for goal in goals:
		goal.connect("player_reached_goal", self, "_on_goal_reached")

func _on_goal_reached(time):
	time_of_last_goal = time
	goals_reached += 1
	print("Goal reached: %d / %d" % [goals_reached, total_goals])
	
	if goals_reached >= total_goals:
		print("All goals reached — restarting level...")
		emit_signal("reload_scene", time_of_last_goal)

