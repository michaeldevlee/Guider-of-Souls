extends Node2D

onready var music_player = get_node("Music")
onready var tween = get_node("Tween")
onready var SFX_player_1 = get_node("SFX_Channel_1")
onready var SFX_player_2 = get_node("SFX_Channel_2")
onready var environ_player_1 = get_node("En_Channel_1")
onready var environ_player_2 = get_node("En_Channel_2")

var SFX_players
var en_SFX_players

func _ready():
	SFX_players = [
	SFX_player_1,
	SFX_player_2
	]
	
	en_SFX_players =[
	environ_player_1,
	environ_player_2
	]


func play_audio(audio : AudioStream):
	if audio:
		music_player.set_stream(audio)
		music_player.play()

func play_SFX(audio : AudioStream , speed):
	for player in SFX_players:
		if !player.stream:
			player.pitch_scale = speed
			player.set_stream(audio)
			player.play()
			yield(player,"finished")
			player.set_stream(null)
			player.pitch_scale = 1
			break

func play_en_SFX(audio : AudioStream , speed):
	for player in en_SFX_players:
		if !player.stream:
			player.pitch_scale = speed
			player.set_stream(audio)
			player.play()
			yield(player,"finished")
			player.set_stream(null)
			player.pitch_scale = 1
			break


func fade_out_audio ():
	if music_player.stream:
		tween.interpolate_property(music_player, "volume_db", 0, -88, 2, Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		music_player.stop()
		music_player.set_volume_db(0)

func fade_in_audio ():
	if music_player.stream:
		tween.interpolate_property(music_player, "volume_db", -88, 0, 2, Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.start()
