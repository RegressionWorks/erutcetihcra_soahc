extends Node
#class_name Global

var Dawn = null
export var MaxGameTime :float = 100.0 
var TimeCounter : float

export(PackedScene) var StartingScene 

onready var transitioner = $CanvasLayer/Transition/AnimationPlayer

func _ready():
	#instance dawn at the begining now
	Dawn = load("res://scenes/Dawn.tscn").instance()
	
	$CanvasLayer/Transition.show()
	transitioner.stop()
	
func _process(delta):
	TimeCounter -= delta
	#change clock volume with time
	if (int(TimeCounter) % 5)==0:
		$SndClock.volume_db = linear2db(TimeCounter / MaxGameTime)
	if (TimeCounter <= 0.0):
		pass #game over here
		
		
func StartGame():
	transitioner.play("trans_out")
	print("starting game")
	yield(get_tree().create_timer(1.0), "timeout")
	
	get_tree().get_current_scene().free()
	
	var StartingScene_inst = StartingScene.instance()
	get_tree().get_root().add_child(StartingScene_inst)
	get_tree().set_current_scene(StartingScene_inst)
	
	#spawn daw
	var SpawnNode = StartingScene_inst.get_node("SpawnPlayerPosition")	
	var DawnFeetPos = Dawn.get_node("Sprite/Ground").position
	StartingScene_inst.add_child(Dawn)
	Dawn.position = SpawnNode.position-DawnFeetPos
	
	transitioner.play("trans_in")
	StartGameClock()

	
func LoadGame():
	pass

func StartGameClock():
	TimeCounter = MaxGameTime
	$SndClock.play()
	
#when a door is activated
func _on_changing_area(next_scene, spawn_door_nodepath):
	print("_on_changing_area")
	
	transitioner.play("trans_out")  #animation are inverted, need to fix
	#wait for transition to finish
	yield(get_tree().create_timer(1.0), "timeout")
	#Dawn.queue_free()
	#Dawn = null
	
	#code could still be executing , defer the call to prevent problems
	call_deferred("_changing_area_phase2", next_scene, spawn_door_nodepath)
		
func _changing_area_phase2(next_scene, spawn_door_nodepath):
	print("deferred : _changing_area_phase2")
	
	#remove Dawn node from the scene before freeing 
	get_tree().get_current_scene().remove_child(Dawn)
	#clean the old scene
	get_tree().get_current_scene().free()

	
	var next_scene_inst = load(next_scene).instance()
	get_tree().get_root().add_child(next_scene_inst)
	get_tree().set_current_scene(next_scene_inst)

	var scene =  next_scene_inst
	
	#spawn the player now that nothing is visible
	var next_door = scene.get_node(spawn_door_nodepath)
	scene.add_child(Dawn)
	Dawn.position = next_door.position + Vector2(0,-14)
	print("dawn ", Dawn, " Pos ",Dawn.position, " ",Dawn.get_path())
	print("Door ", next_door, " Pos ", next_door.position," ", next_door.get_path())
	
	transitioner.play("trans_in")
	
	
func _debug_infos():
	print("dawn ", Dawn)
	print(" Pos ",Dawn.position, " ", Dawn.get_path())
