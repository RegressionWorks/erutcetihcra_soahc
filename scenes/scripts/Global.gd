extends Node
class_name Global

var Dawn = null
var Door


var SceneChanger
var previous_room
var previous_door
export var MaxGameTime :float = 100.0 
var TimeCounter : float


signal area_changed()

onready var transitioner = $CanvasLayer/Transition/AnimationPlayer

func _ready():
	Global.SceneChanger = self
	$CanvasLayer/Transition.show()
	
func _process(delta):
	TimeCounter -= delta
	#change clock volume with time
	if (int(TimeCounter) % 5)==0:
		$SndClock.volume_db = linear2db(TimeCounter / MaxGameTime)
	if (TimeCounter <= 0.0):
		pass #game over here

func StartGameClock():
	TimeCounter = MaxGameTime
	$SndClock.play()
	
func _on_Door_changing_area():
	transitioner.play("trans_in")