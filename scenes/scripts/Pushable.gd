extends RigidBody2D
class_name Pushable, "res://assets/gfx/props/WoodenBox.png"

var velocity : Vector2 = Vector2.ZERO
var gravity : float = 80

func _ready():
	add_to_group("Pushable")


func _physics_process(delta):
#	velocity.y = gravity
#	velocity = move_and_slide(velocity, Vector2.UP)
#	#some friction
#	velocity.x*=0.90
	
	#velocity.y = gravity
	#velocity.x = 
	#move_and_slide(velocity, Vector2.UP)
	pass
