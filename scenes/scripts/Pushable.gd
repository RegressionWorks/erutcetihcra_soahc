extends KinematicBody2D
class_name Box

var motion : Vector2 = Vector2.ZERO

func push(motion: Vector2) -> void:
	move_and_slide(motion, Vector2())