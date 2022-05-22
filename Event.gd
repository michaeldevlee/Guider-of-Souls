extends Node2D

func initiate():
	print("hello")
	terminate_event()


func terminate_event():
	EventBus.emit_signal("update_player_move_status", true)
