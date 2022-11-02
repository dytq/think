extends Node2D

var current_line : Line2D
var is_actived : bool

func _unhandled_input(event):
	if event is InputEventMouseButton:
		current_line = Line2D.new()
		current_line.default_color = Color.BLACK
		current_line.width = 5.0
		add_child(current_line)
		is_actived = !is_actived

func _process(_delta):
	if(is_actived):
		current_line.add_point(get_global_mouse_position())
