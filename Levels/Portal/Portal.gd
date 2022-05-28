extends Node2D

export var next_level_location_path : NodePath
var next_level_location : Vector2
var currently_teleporting : bool = false

func _ready():
	if next_level_location_path:
		next_level_location = get_node(next_level_location_path).global_position
		print(next_level_location)

func teleport(player : Player):
	if next_level_location and player:
		if !currently_teleporting:
			currently_teleporting = true
			EventBus.emit_signal("update_player_move_status", false)
			TransitionManager.play_fade_out(0.8)
			AudioManager.play_SFX(Sfx.get_ability, 1.7)
			yield(TransitionManager.anim_player, "animation_finished")
			currently_teleporting = false
			player.global_position = next_level_location
			EventBus.emit_signal("update_player_move_status", true)
			TransitionManager.play_fade_in(0.8)
