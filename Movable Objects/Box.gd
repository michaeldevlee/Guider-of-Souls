extends KinematicBody2D
class_name Box

func on_collide(player_position):
	var velocity = position.direction_to(player_position) * 1000
	velocity = move_and_slide(velocity)
	
func push(velocity):
	print("pushing")
	velocity = move_and_slide(velocity)
