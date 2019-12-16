extends KinematicBody2D
class_name Player



var anim_state
var walk_speed := 30
var run_speed := 40
var push_speed := 20
var gravity := 40
var is_pushing = false
var on_floor
var on_stair_left = false
var on_stair_right = false

var motion : Vector2 = Vector2.ZERO
const UP := Vector2.DOWN



func _ready():
	show()
	anim_state = $AnimationTree.get("parameters/playback")
	$AnimationTree.active = true
	Global.Dawn = self
	

#var state_normal():
#	pass

#var state_push():
#	pass


func _physics_process(delta: float) -> void:
	get_input()
	gravity()
	get_anim()
	sprite_dir()
	in_floor()
	motion = move_and_slide(motion, UP)
	


func get_input():
	motion = Vector2.ZERO
	if Input.is_action_pressed("ui_right") && on_floor:
		motion.x += 1
	if Input.is_action_pressed("ui_left") && on_floor:
		motion.x -= 1
	
	if on_stair_left:
		if Input.is_action_pressed("ui_up"):
			motion.x -= 1
			motion.y -= 1
		if Input.is_action_pressed("ui_down"):
			motion.x += 1
			motion.y += 1
	
	if on_stair_right:
		if Input.is_action_pressed("ui_up"):
			motion.x += 1
			motion.y -= 1
		if Input.is_action_pressed("ui_down"):
			motion.x -= 1
			motion.y += 1
	motion = motion.normalized() * walk_speed
	
	if Input.is_action_pressed("run"):
		if (!on_stair_left and !on_stair_right):
			motion = motion.normalized() * run_speed
	


func gravity():
	if !is_on_floor() and (!on_stair_left and !on_stair_right):
		motion.y += gravity
		if motion.y >= gravity:
			motion.y = gravity


func get_anim():
	if motion.x == 0:
		anim_state.travel("idle")
	elif motion.x < 0 or motion.x > 0:
		anim_state.travel("walk")
	

func sprite_dir():
	if motion.x <= -1:
		$Sprite.scale.x = -1
	if motion.x >= 1:
		$Sprite.scale.x = 1


func in_floor():
	if Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
		$FloorRay.position.x = 3
	if Input.is_action_pressed("ui_left") && !Input.is_action_pressed("ui_right"):
		$FloorRay.position.x = -3
	on_floor = $FloorRay.is_colliding()
