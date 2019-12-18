extends Node
class_name Global

var Dawn = null
var Door


var SceneChanger
var previous_room
var previous_door
var minutes_left = 1


signal area_changed()

onready var transitioner = $CanvasLayer/Transition/AnimationPlayer

func _ready():
	Global.SceneChanger = self
	$CanvasLayer/Transition.show()


func _on_Door_changing_area():
	transitioner.play("trans_in")