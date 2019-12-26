extends KinematicBody2D
class_name Player


var anim_state
var walk_speed : float = 30.0
var run_speed : float = 40.0
var push_speed : float = 20.0
var gravity : float = 80.0
var is_pushing : bool = false
var pushing_offset :float = 0.0
var on_stairs : bool = false
var stairs_in_front : bool = false
var want_to_go_on_stairs : bool = false
var velocity : Vector2 = Vector2.ZERO


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
	push_objects(delta)	
	set_animation()
	set_sprite_direction()
	manage_stairs()
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true, 4, 0.8, false)
	#motion = move_and_slide(motion,Vector2.UP)


func get_input():
	velocity = Vector2.ZERO
	
	#check for pushable
	if Input.is_action_pressed("interact") && $Sprite/PushableRay.is_colliding() && !is_pushing:
		is_pushing = true
		pushing_offset=global_position.x-$Sprite/PushableRay.get_collider().global_position.x
		print(pushing_offset)
		anim_state.travel("push_wait")
	#print("interact ",Input.is_action_pressed("interact"), " Collide ", $Sprite/PushableRay.is_colliding())
	if (Input.is_action_just_released("interact") && is_pushing)  || $Sprite/PushableRay.get_collider() == null:
		is_pushing = false
	
	if Input.is_action_pressed("ui_right"):# && is_on_floor():
		velocity.x = 1
	if Input.is_action_pressed("ui_left"):# && is_on_floor():
		velocity.x = -1
		
	if is_pushing:	
		velocity = velocity.normalized() * walk_speed * 0.5
		$Sprite/PushableRay.get_collider().global_position.x = global_position.x - pushing_offset
		#$Sprite/PushableRay.get_collider().linear_velocity.x=velocity.x
	else:
		want_to_go_on_stairs = Input.is_action_pressed("ui_up") && is_on_floor()
	
		if (on_stairs && stairs_in_front && !go_through_stairs):
			velocity = velocity.normalized() * walk_speed *2.0
		else:
			velocity = velocity.normalized() * walk_speed
		
		if Input.is_action_pressed("run"):
			if !on_stairs:
				velocity = velocity.normalized() * run_speed
		
	
			
func gravity():
	if (on_stairs):
		velocity.y = gravity/80.0
	else:
		velocity.y = gravity
		
func push_objects(delta):
	#var collision = move_and_collide(velocity * delta, true, true, true)
	for i in get_slide_count():
		var collider : Pushable = get_slide_collision(i).collider as Pushable		
		pass
#		if collider != null:
#			collider.velocity += velocity * 0.1


func set_animation():
	if (is_pushing):
		if velocity.x == 0:
			pass
		else:
			anim_state.travel("push")
	else:
		if velocity.x == 0:
			anim_state.travel("idle")
		else:
			anim_state.travel("walk")
	

func set_sprite_direction():
	if !is_pushing:
		if velocity.x <= -1:
			$Sprite.scale.x = -1
		elif velocity.x >= 1:
			$Sprite.scale.x = 1


var last_want_collide_stairs : bool = false
var colliding_stairs = null
var go_through_stairs : bool = false;

func manage_stairs():
	on_stairs = $Sprite/StairRayDown.is_colliding()	
	#$Sprite/StairRayDown.get_collider()
	stairs_in_front = $Sprite/StairRayFront.is_colliding()
	var stairs_up = $Sprite/StairRayUp.is_colliding()
	#print("up ",  stairs_up)
	#print("down " + String(on_stairs))
	#print("up " + String(stairs_up))
	
	var want_collide_stairs = true
	
	if (go_through_stairs):
		want_collide_stairs = false
		if (!on_stairs && !stairs_in_front):
			go_through_stairs = false		
	else:	
		if (!want_to_go_on_stairs):
			if(!on_stairs || stairs_up):
				want_collide_stairs=false
			
			if (!on_stairs && stairs_in_front):
				want_collide_stairs = false 
				go_through_stairs =true;
		
	last_want_collide_stairs = want_collide_stairs

	#print(want_collide_stairs, " infront ", stairs_in_front)
	set_collision_mask_bit(3, want_collide_stairs)

