extends KinematicBody2D


func on_collide(player_position):
	var velocity = position.direction_to(player_position) * 1000
	velocity = move_and_slide(velocity)
	
