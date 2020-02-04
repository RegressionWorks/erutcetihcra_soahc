extends Node2D

var menu_shown = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuCanvas/HBoxContainer/LblNewgame.grab_focus()
	$MenuCanvas/HBoxContainer.modulate.a = 0.0
	$Timer.start()


func _on_Timer_timeout():
	menu_shown = true
	$Tween.interpolate_property($MenuCanvas/HBoxContainer, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	
func _input(event):
	if event is InputEventKey && ! menu_shown:
		$Title/AnimationPlayer.seek(24, true)
		$Timer.wait_time =0.01
		$Timer.start()
		
func OnMenuAction(MenuAction):
	if !menu_shown:
		return
	match MenuAction:
		MenuLabel.EMenuAction.NewGame:
			$MenuCanvas/HBoxContainer.visible = false
			Global.StartGame()
		MenuLabel.EMenuAction.LoadGame:
			$MenuCanvas/HBoxContainer.visible = false
			Global.LoadGame()
		MenuLabel.EMenuAction.Options:
			$MenuCanvas/HBoxContainer.visible = false
		MenuLabel.EMenuAction.Quit:
			get_tree().quit()
