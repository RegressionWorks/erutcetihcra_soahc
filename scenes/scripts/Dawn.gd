extends KinematicBody2D
class_name Player


var anim_state
var walk_speed : float = 30.0
var run_speed : float = 40.0
var push_speed : float = 20.0
var gravity : float = 80.0
var is_pushing : bool = false
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
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true, 4, 0.8)
	#motion = move_and_slide(motion,Vector2.UP)


func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right") && is_on_floor():
		velocity.x = 1
	if Input.is_action_pressed("ui_left") && is_on_floor():
		velocity.x = -1
		
	want_to_go_on_stairs = Input.is_action_pressed("ui_up") && is_on_floor()

	if (on_stairs && stairs_in_front):
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
		if collider != null:
			collider.velocity += velocity * 0.1


func set_animation():
	if velocity.x == 0:
		anim_state.travel("idle")
	else:
		anim_state.travel("walk")
	

func set_sprite_direction():
	if velocity.x <= -1:
		$Sprite.scale.x = -1
	elif velocity.x >= 1:
		$Sprite.scale.x = 1


var last_want_collide_stairs : bool = false
var colliding_stairs = null

func manage_stairs():
	on_stairs = $Sprite/StairRayDown.is_colliding()	
	#$Sprite/StairRayDown.get_collider()
	stairs_in_front = $Sprite/StairRayFront.is_colliding()
	var stairs_up = $Sprite/StairRayUp.is_colliding()
	
	#print("down " + String(on_stairs))
	#print("up " + String(stairs_up))
	
	var want_collide_stairs = true
	
	if (!want_to_go_on_stairs):
		if(!on_stairs || stairs_up):
			want_collide_stairs=false
		
		if (!on_stairs && stairs_in_front):
			want_collide_stairs = false 
	else:
		want_collide_stairs = true
		
	
		
	last_want_collide_stairs = want_collide_stairs

	#print(want_collide_stair)
	set_collision_mask_bit(3, want_collide_stairs)

