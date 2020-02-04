extends Label
class_name MenuLabel

enum EMenuAction {NewGame, LoadGame, Options, Quit}

export(int, "NewGame","LoadGame", "Options", "Quit") var MenuAction

signal sig_menu_action

# Called when the node enters the scene tree for the first time.
func _ready():
	set_focus_mode(Control.FOCUS_ALL)
	connect("focus_entered", self,"on_focus_entered")
	connect("focus_exited", self,"on_focus_exited")
	
	var IntMenuNode = get_parent().get_parent().get_parent()  
	connect("sig_menu_action", IntMenuNode, "OnMenuAction")

func on_focus_entered():
	modulate = Color(0.8, 1.0, 0.8, 1.0)
func on_focus_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	
func _input(event):
	if !visible:
		return
	if event.is_action_pressed("ui_accept"):
		emit_signal("sig_menu_action", MenuAction)
