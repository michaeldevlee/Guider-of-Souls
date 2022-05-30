extends Node2D

onready var ambience_player = get_node("Rain")

func _ready():
	TransitionManager.play_fade_in(0.8)
	yield(TransitionManager.anim_player, "animation_finished")


func start_game():
	TransitionManager.play_fade_out(0.8)
	AudioManager.fade_out_audio()
	yield(TransitionManager.anim_player, "animation_finished")
	get_tree().change_scene("res://Main.tscn")
