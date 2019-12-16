extends Area2D



func _on_StairsAreaRight_body_entered(body):
	if body.name == "Dawn":
		get_node("../Dawn").on_stair_right = true


func _on_StairsAreaRight_body_exited(body):
	if body.name == "Dawn":
		get_node("../Dawn").on_stair_right = false
