extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_focus_mode(Control.FOCUS_ALL)
	connect("focus_entered", self,"on_focus_entered")
	connect("focus_exited", self,"on_focus_exited")

func on_focus_entered():
	modulate = Color(0.8, 1.0, 0.8, 1.0)
func on_focus_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
