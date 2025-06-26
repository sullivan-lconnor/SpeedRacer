extends Node2D

func _draw():
	var parent = get_parent()
	if parent.has_method("get"):
		var size = parent.size
		var color = parent.color
		draw_rect(Rect2(-size / 2, size), color)
