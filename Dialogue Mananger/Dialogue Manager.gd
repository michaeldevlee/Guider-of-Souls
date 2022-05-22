extends Node2D

onready var bubble = get_node("CanvasLayer/MarginContainer")
onready var tween = get_node("Tween")

export var bubble_text_path: NodePath

var bubble_text

var dialogue_resource
var index
var dialogues
var next_actions

var currently_in_dialogue : bool = false

signal dialogue_started (dialogue_object)

func _ready():
	if bubble_text_path:
		bubble_text = get_node(bubble_text_path)
	
	initialize_signals()
	
	
		
func handle_dialogue(dialogue_object):
	
	if dialogue_resource == null:
		dialogue_resource = dialogue_object
	
	if dialogues == null and next_actions == null:
		initiate_text(dialogue_object)
	
	if currently_in_dialogue and next_actions:
		start_next_event()
	
	if !currently_in_dialogue and dialogues:
		initiate_text_bubble()
		

func initiate_text(dialogue_object):
	if dialogue_resource and dialogue_resource is Dialogue:
		dialogues = dialogue_object.dialogue_array
		next_actions = dialogue_object.next_action
		index = 0

func initiate_text_bubble():
	bubble.set_visible(true)
	bubble_text.set_text(dialogues[0])
	currently_in_dialogue = true
	EventBus.emit_signal("update_player_move_status", false)
	reveal_text_animation()

func start_next_event():
	match next_actions[index]:
		"NEXT":
			index += 1;
			update_text()
		"END":
			currently_in_dialogue = false
			EventBus.emit_signal("update_player_move_status", true)
			close_text()

func update_text():
	bubble_text.set_text(dialogues[index])
	reveal_text_animation()

func close_text():
	bubble.set_visible(false)
	dialogues = null
	next_actions = null
	index = 0

func reveal_text_animation():
	tween.interpolate_property(bubble_text, "percent_visible", 0, 1, 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()


func initialize_signals():
	DialogueManager.connect("dialogue_started", self, "handle_dialogue")
