extends Node2D

var menu_shown = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuCanvas/HBoxContainer/LblLoadGame.grab_focus()
	$MenuCanvas/HBoxContainer.modulate.a = 0.0
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	menu_shown = true
	$Tween.interpolate_property($MenuCanvas/HBoxContainer, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR)
	$Tween.start()
	
	
func _input(event):
	if event is InputEventKey && ! menu_shown:
		$Timer.wait_time =0.01
		$Timer.start()
		
