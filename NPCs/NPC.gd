extends Node2D

export var dialogue : Resource
export var event_path : NodePath
export(String, "LIGHT") var ability = "LIGHT"

var event
var can_interact : bool = false

func _ready():
	initialize_signals()
	if event_path :
		event = get_node(event_path)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		can_interact = true


func _on_Area2D_body_exited(body):
	# TODO: this should be called when NPC is killed.
	on_death();
	if body.name == "Player":
		can_interact = false

func on_death():
	EventBus.emit_signal("add_ability", ability)

func initiate_conversation():
	DialogueManager.emit_signal("dialogue_started", self)
	
func start_event(NPC):
	if NPC == self:
		event.initiate();

func _input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		initiate_conversation()

func initialize_signals():
	EventBus.connect("initiate_event", self, "start_event")
