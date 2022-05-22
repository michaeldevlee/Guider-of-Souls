extends Node2D

func initiate():
	print("hello")
	yield(get_tree().create_timer(3), "timeout")
	print("bye")
	terminate_event()


func terminate_event():
	EventBus.emit_signal("update_player_move_status", true)
