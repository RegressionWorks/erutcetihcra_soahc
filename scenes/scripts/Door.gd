extends Area2D
class_name Door

export (String, FILE) var next_room_path := ""
export (String) var next_room_door_name := ""

var enabled

signal changing_area
signal area_changed


func _ready():
	add_to_group("Door")
	Global.Door = self

func _process(delta):
	if Input.is_action_just_pressed("interact") && enabled:
		emit_signal("changing_area")
		Global.Dawn.set_physics_process(false)
		yield(get_tree().create_timer(0.8), "timeout")
		enter_door()

func enter_door():
	emit_signal("area_changed")
	get_tree().change_scene(next_room_path)
	Global.previous_door = self
	Global.previous_room = get_parent().get_name()

func _on_FrontDoor_body_entered(body):
	if body.name == "Dawn":
		enabled = true
		$AnimationPlayer.play("open")


func _on_FrontDoor_body_exited(body):
	if body.name == "Dawn":
		enabled = false
		$AnimationPlayer.play("close")

