extends Node
class_name Global

var Dawn = null
var previous_room = null
export var MaxGameTime :float = 100.0 
var TimeCounter : float


signal area_changed

onready var transitioner = $CanvasLayer/Transition/AnimationPlayer

func _ready():
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
	
#when a door is activated
func _on_changing_area(next_scene, spawn_door_nodepath):
	#Dawn.set_physics_process(false)
	transitioner.play("trans_in")  #animation are inverted, need to fix
	#wait for transition to finish
	yield(get_tree().create_timer(1.0), "timeout")
	#get_tree().get_current_scene().queue_free()
	get_tree().change_scene(next_scene)
	
	#spawn the player now that nothing is visible
	var scene = get_tree().get_current_scene()
	var next_door = scene.get_node(spawn_door_nodepath)
	var SpawnedPlayer = load("res://scenes/Dawn.tscn").instance()
	scene.add_child(SpawnedPlayer)
	SpawnedPlayer.position = next_door.position #+Vector2(10,-4)

	print("Level ",scene.position, scene.global_position)
	print("dawn ", SpawnedPlayer, " Pos ",SpawnedPlayer.position, " ",SpawnedPlayer.get_path())
	print("Door ", next_door, " Pos ", next_door.position," ", next_door.get_path())
	
	transitioner.play("trans_out")
	
	