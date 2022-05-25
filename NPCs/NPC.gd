extends Node2D
class_name NPC

export var dialogue : Resource
export var event_path : NodePath
export(String, "LIGHT") var ability = "LIGHT"

onready var anim_player = get_node("AnimationPlayer")

var event
var soul_collected : bool = false

func _ready():
	initialize_signals()
	if event_path :
		event = get_node(event_path)

func play_death_anim():
	anim_player.play("Death")

func on_death_anim_finished(anim_name : String):
	if anim_name == "Death":
		EventBus.emit_signal("add_ability", ability)
		soul_collected = true

func initiate_conversation():
	DialogueManager.emit_signal("dialogue_started", dialogue)
	
func start_event(dialogue_object):
	if dialogue_object == dialogue:
		DialogueManager.player_ready_for_dialogue = false
		event.initiate(self);

func initialize_signals():
	EventBus.connect("initiate_event", self, "start_event")
	anim_player.connect("animation_finished", self, "on_death_anim_finished")
