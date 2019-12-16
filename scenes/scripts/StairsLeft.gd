extends Area2D

func _on_StairsAreaLeft_body_entered(body):
	if body.name == "Dawn":
		get_node("../Dawn").on_stair_left = true

func _on_StairsAreaLeft_body_exited(body):
	if body.name == "Dawn":
		get_node("../Dawn").on_stair_left = false