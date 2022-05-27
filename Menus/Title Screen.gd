extends Control

func _ready():
	TransitionManager.play_fade_in(0.8)
	yield(TransitionManager.anim_player, "animation_finished")
	AudioManager.play_audio(Songs.title_music)


func _on_Play_Button_button_up():
	TransitionManager.play_fade_out(0.8)
	AudioManager.fade_out_audio()
	yield(TransitionManager.anim_player, "animation_finished")
	get_tree().change_scene("res://Main.tscn")
