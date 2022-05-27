extends Node2D

export var next_level_location_path : NodePath
var next_level_location : Vector2

func _ready():
	if next_level_location_path:
		next_level_location = get_node(next_level_location_path).global_position
		print(next_level_location)

func teleport(player : Player):
	if next_level_location and player:
		player.global_position = next_level_location
