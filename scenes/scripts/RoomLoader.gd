extends Node

onready var scene_tree := get_tree()

var _game : Node = null
var _player : Player = null
var _room : Node2D = null

func setup(game: Node, player: Player, Room: PackedScene) -> void:
	_game = game
	_player = player
	pass
