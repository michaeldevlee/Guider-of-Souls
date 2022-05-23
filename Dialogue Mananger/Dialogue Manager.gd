extends Node2D

onready var bubble = get_node("CanvasLayer/MarginContainer")
onready var tween = get_node("Tween")

export var bubble_text_path: NodePath


var bubble_text
var seconds

var dialogue_resource
var index
var dialogues
var next_actions
var current_NPC

var currently_in_dialogue : bool = false

signal dialogue_started (NPC)

func _ready():
	if bubble_text_path:
		bubble_text = get_node(bubble_text_path)
	
	initialize_signals()
	
	
		
func handle_dialogue(NPC):
	
	current_NPC = NPC;
	
	if dialogue_resource == null:
		dialogue_resource = NPC.dialogue
	
	if dialogues == null and next_actions == null:
		initiate_text(dialogue_resource.dialogue_array)
	
	if currently_in_dialogue and next_actions:
		start_next_event()
	
	if !currently_in_dialogue and dialogues:
		initiate_text_bubble()
		

func initiate_text(NPC):
	if dialogue_resource and dialogue_resource is Dialogue:
		dialogues = dialogue_resource.dialogue_array
		next_actions = dialogue_resource.next_action
		index = 0

func initiate_text_bubble():
	bubble.set_visible(true)
	bubble_text.set_text(dialogues[0])
	currently_in_dialogue = true
	EventBus.emit_signal("update_player_move_status", false)
	reveal_text_animation()

func start_next_event():
	
	if tween.is_active():
		tween.playback_speed = 4
	
	match next_actions[index]:
		"NEXT":
			if !tween.is_active():
				index += 1;
				update_text()
				tween.playback_speed = 1
		"END":
			if !tween.is_active():
				currently_in_dialogue = false
				EventBus.emit_signal("update_player_move_status", true)
				close_text()
		"EVENT":
			if !tween.is_active():
				EventBus.emit_signal("initiate_event", current_NPC)
				close_text()

func update_text():
	bubble_text.set_text(dialogues[index])
	reveal_text_animation()

func close_text():
	bubble.set_visible(false)
	dialogues = null
	next_actions = null
	current_NPC = null
	dialogue_resource = null
	currently_in_dialogue = false
	index = 0

func reveal_text_animation():
	seconds = 0.05 * bubble_text.get_total_character_count()
	tween.interpolate_property(bubble_text, "percent_visible", 0, 1, seconds,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()


func initialize_signals():
	DialogueManager.connect("dialogue_started", self, "handle_dialogue")
