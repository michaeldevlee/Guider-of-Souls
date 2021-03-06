extends Node2D

func _ready():
	register_signals()
	game_init()

func register_signals():
	EventBus.connect("game_started", self, "game_init")

func game_init():
	TransitionManager.play_fade_in(1)
	yield(TransitionManager.anim_player, "animation_finished")
	AudioManager.play_audio(Songs.gameplay_music_2)
	AudioManager.play_en_SFX(Songs.cave_drops, 1)
	AudioManager.play_en_SFX(Songs.cave_air, 1)
