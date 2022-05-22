extends Node2D

export var dialogue : Resource

var can_interact : bool = false


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		can_interact = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		can_interact = false

func initiate_conversation():
	DialogueManager.emit_signal("dialogue_started", dialogue)

func _input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		initiate_conversation()
