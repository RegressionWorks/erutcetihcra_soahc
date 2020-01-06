extends Node
class_name Level

export var LevelName : String ="LevelName"

func _input(event):
	if event is InputEventMouseButton:
		Global._debug_infos()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		print("Level predelete")