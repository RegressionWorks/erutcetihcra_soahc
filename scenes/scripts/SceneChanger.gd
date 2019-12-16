extends Node

signal area_changed()

onready var transitioner = $CanvasLayer/Transition/AnimationPlayer

func _ready():
	Global.SceneChanger = self
	$CanvasLayer/Transition.show()


func _on_Door_changing_area():
	transitioner.play("trans_in")

