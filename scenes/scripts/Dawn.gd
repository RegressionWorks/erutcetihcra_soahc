extends KinematicBody2D
class_name Player



var anim_state
var walk_speed := 30.0
var run_speed := 40.0
var push_speed := 20.0
var gravity := 25.0
var is_pushing : bool = false
var on_stairs : bool = false
var stairs_in_front : bool = false
var want_to_go_on_stairs : bool = false
var motion : Vector2 = Vector2.ZERO


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
	set_animation()
	set_sprite_direction()
	manage_stairs()
	motion = move_and_slide_with_snap(motion, Vector2.DOWN, Vector2.UP, true, 4, 0.8)
	#motion = move_and_slide(motion,Vector2.UP)


func get_input():
	motion = Vector2.ZERO
	if Input.is_action_pressed("ui_right") && is_on_floor():
		motion.x = 1
	if Input.is_action_pressed("ui_left") && is_on_floor():
		motion.x = -1
		
	want_to_go_on_stairs = Input.is_action_pressed("ui_up") && is_on_floor()

	if (on_stairs && stairs_in_front):
		motion = motion.normalized() * walk_speed *2.0
	else:
		motion = motion.normalized() * walk_speed
	
	if Input.is_action_pressed("run"):
		if !on_stairs:
			motion = motion.normalized() * run_speed
	
	
	


func gravity():
	if (on_stairs):
		motion.y=gravity/10.0
	else:
		motion.y = gravity


func set_animation():
	if motion.x == 0:
		anim_state.travel("idle")
	elif motion.x < 0 or motion.x > 0:
		anim_state.travel("walk")
	

func set_sprite_direction():
	if motion.x <= -1:
		$Sprite.scale.x = -1
	elif motion.x >= 1:
		$Sprite.scale.x = 1


func manage_stairs():
	var last = on_stairs
	on_stairs = $Sprite/StairRayDown.is_colliding()	
	#$Sprite/StairRayDown.get_collider()
	stairs_in_front = $Sprite/StairRayFront.is_colliding()
	
	var collide_stair = true
	
	
	if (!on_stairs):
		if stairs_in_front && !want_to_go_on_stairs:
			collide_stair = false 
	
	

#	if (on_stairs && !is_on_floor()):
#		collide_stair=true
#
#	if (want_to_go_on_stairs):
#		collide_stair = true
#
#	if (on_stairs && last):
#		collide_stair = true
#
	print(collide_stair)
	set_collision_mask_bit(3, collide_stair)

