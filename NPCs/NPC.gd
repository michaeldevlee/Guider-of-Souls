extends Node2D
class_name NPC

export var dialogue : Resource
export var event_path : NodePath
export(String, "LIGHT", "GRAB", "PUSH") var ability = "GRAB"

onready var anim_player = get_node("AnimationPlayer")
onready var idle_player = get_node("AnimationPlayer2")
onready var collision_shape = get_node("KinematicBody2D/CollisionShape2D")

var event
var soul_collected : bool = false

func _ready():
	initialize_signals()
	idle_player.play("Idle")
	if event_path :
		event = get_node(event_path)

func play_death_anim():
	anim_player.play("Death")

func on_death_anim_finished(anim_name : String):
	if anim_name == "Death":
		EventBus.emit_signal("add_ability", ability)
		soul_collected = true
		collision_shape.disabled = true

func initiate_conversation():
	if !soul_collected:
		DialogueManager.emit_signal("dialogue_started", dialogue)
	
func start_event(dialogue_object):
	if dialogue_object == dialogue:
		DialogueManager.player_ready_for_dialogue = false
		event.initiate(self);

func initialize_signals():
	EventBus.connect("initiate_event", self, "start_event")
	anim_player.connect("animation_finished", self, "on_death_anim_finished")
