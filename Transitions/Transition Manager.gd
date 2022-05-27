extends CanvasLayer

onready var anim_player = get_node("AnimationPlayer")

func play_fade_in(speed):
	anim_player.playback_speed = speed
	anim_player.play("Fade In")
	
func play_fade_out(speed):
	anim_player.playback_speed = speed
	anim_player.play("Fade Out")
