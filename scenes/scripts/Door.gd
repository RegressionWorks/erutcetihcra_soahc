tool
extends Area2D
class_name Door

enum EDoorType { Front, Side }
export (EDoorType) var DoorType = EDoorType.Front setget _set_door_type
export (String, FILE) var next_room_path := ""
export (NodePath) var connected_door := ""

var opened : bool = false

signal changing_area

func _ready():
	add_to_group("Door")
	connect("changing_area", get_node("/root/Global"), "_on_changing_area")
	
func _set_door_type(value):
	DoorType = value
	if DoorType == EDoorType.Front:		
		$CollisionFront.disabled=false
		$CollisionSide.disabled=true
		$AnimPlayer.play("closed")
	else:
		$CollisionFront.disabled=true
		$CollisionSide.disabled=false
		$AnimPlayer.play("side_closed")

func _process(delta):
	if Input.is_action_just_pressed("interact") && opened:
		print("Enter door")
		emit_signal("changing_area", next_room_path, connected_door)
	

func _on_FrontDoor_body_entered(body):
	if body.name == "Dawn" && !opened:
		print("Door opening")
		opened = true
		if DoorType == EDoorType.Front:
			$AnimPlayer.play("open")
		else:
			$AnimPlayer.play("side_open")	
		$SndOpen.play()

func _on_FrontDoor_body_exited(body):
	if body.name == "Dawn" && opened:
		opened = false
		if DoorType == EDoorType.Front:
			$AnimPlayer.play("close")
		else:
			$AnimPlayer.play("side_close")	
		$SndClose.play()
