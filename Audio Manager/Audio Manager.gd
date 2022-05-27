extends Node2D

onready var music_player = get_node("Music")
onready var tween = get_node("Tween")

func play_audio(audio : AudioStream):
	if audio:
		music_player.set_stream(audio)
		music_player.play()

func fade_out_audio ():
	if music_player.stream:
		tween.interpolate_property(music_player, "volume_db", 0, -88, 2, Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		music_player.stop()
		music_player.set_volume_db(0)

func fade_in_audio ():
	if music_player.stream:
		tween.interpolate_property(music_player, "volume_db", 0, -88, 2, Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.start()
