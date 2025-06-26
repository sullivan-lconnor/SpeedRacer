extends Area2D

signal player_reached_goal(time)

var time_alive := 0.0

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	time_alive += delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_reached_goal", time_alive)
		# print("Goal was reached in %.2f seconds" % time_alive)
		queue_free()
