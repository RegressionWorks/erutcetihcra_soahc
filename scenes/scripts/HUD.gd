extends CanvasLayer

signal scene_changed()

onready var transitioner = $Transition/AnimationPlayer

func _ready():
	#$Transition.show()
	transitioner.play("trans_out")

func process(delta):
	pass

func change_scene(path, delay = 0.8):
	yield(get_tree().create_timer(delay), "timeout")
	transitioner.play("trans_in")
	yield(transitioner, "animation_finished")
	emit_signal("scene_changed")