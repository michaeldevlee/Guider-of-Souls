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
var player_ready_for_dialogue : bool = false

var currently_in_dialogue : bool = false

signal dialogue_started (dialogue_object)

func _ready():
	if bubble_text_path:
		bubble_text = get_node(bubble_text_path)
	
	initialize_signals()
	
func start_dialogue(dialogue_object):
	if dialogue_resource == null and dialogue_object:
		dialogue_resource = dialogue_object
	
	if dialogues == null and next_actions == null:
		initiate_text(dialogue_resource.dialogue_array)
	
	if !currently_in_dialogue and dialogues:
		initiate_text_bubble()

		
func handle_dialogue():
	
	if currently_in_dialogue and next_actions:
		start_next_event()
	

func initiate_text(dialogue_object):
	if dialogue_resource and dialogue_resource is Dialogue:
		dialogues = dialogue_resource.dialogue_array
		next_actions = dialogue_resource.next_action
		index = 0

func initiate_text_bubble():
	bubble_text.percent_visible = 0
	bubble_text.set_text(dialogues[0])
	bubble.set_visible(true)
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
				EventBus.emit_signal("initiate_event", dialogue_resource)
				close_text()

func update_text():
	bubble_text.set_text(dialogues[index])
	reveal_text_animation()

func close_text():
	bubble.set_visible(false)
	bubble_text.set_text("")
	dialogues = null
	next_actions = null
	dialogue_resource = null
	currently_in_dialogue = false
	index = 0

func reveal_text_animation():
	seconds = 0.05 * bubble_text.get_total_character_count()
	tween.interpolate_property(bubble_text, "percent_visible", 0, 1, seconds,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	print("updating text")

func initialize_signals():
	DialogueManager.connect("dialogue_started", self, "start_dialogue")

func _input(event):
	if Input.is_action_just_pressed("interact"):
		if currently_in_dialogue:
			handle_dialogue()
		elif !currently_in_dialogue and player_ready_for_dialogue:
			start_dialogue(dialogue_resource)
