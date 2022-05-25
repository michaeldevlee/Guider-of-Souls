extends KinematicBody2D


onready var anim_player = get_node("AnimationPlayer")
export (int) var speed = 200
var ability_nodes = {
	Abilities.LIGHT: "Abilities/Light"
}

var available_abilities = []
var current_ability
var currently_in_event : bool = false

var can_move : bool = true
var can_interact : bool = false
var interaction_object = null

var velocity = Vector2()

func _ready():
	initialize_signals()

func get_input():
	
	if velocity == Vector2() and !currently_in_event:
		anim_player.play("Idle")
	
	if !can_move:
		return
	
	if Input.is_action_just_pressed("use_ability"):
		toggle_ability()
	
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		anim_player.play("Walk Right")
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		anim_player.play("Walk Left")
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		anim_player.play("Walk Down")
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		anim_player.play("Walk Up")
	velocity = velocity.normalized() * speed

func initialize_signals():
	EventBus.connect("update_player_move_status", self, "set_move_status")
	EventBus.connect("add_ability", self, "add_ability")
	UiManager.connect("update_current_ability", self, "update_current_ability")

func set_move_status(status : bool):
	can_move = status
	velocity = Vector2()

func toggle_ability():
	if not current_ability:
		return
	var ability = get_node(ability_nodes[current_ability])
	ability.visible = not ability.visible
	
func add_ability(name):
	if not name in available_abilities:
		can_move = false
		currently_in_event = true
		yield(player_gained_ability_anim(),"completed")
		currently_in_event = false
		available_abilities.append(name)
		DialogueManager.emit_signal("dialogue_started", Abilities.abilities_gained_text_list[name])
		UiManager.emit_signal("update_skills", name)
		DialogueManager.player_ready_for_dialogue = true

func update_current_ability(name):
	current_ability = name

func player_gained_ability_anim():
	anim_player.play("Take Soul")
	yield(anim_player, "animation_finished")

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func _on_Interact_Area_area_entered(area):
	if area.is_in_group("NPC"):
		interaction_object = area.owner
		
		if interaction_object.soul_collected == false:
			DialogueManager.player_ready_for_dialogue = true

func _on_Interact_Area_area_exited(area):
	if area.is_in_group("NPC"):
		interaction_object = null
		DialogueManager.player_ready_for_dialogue = false

func _input(event):
	if Input.is_action_just_pressed("interact") and DialogueManager.player_ready_for_dialogue:
		interaction_object.initiate_conversation()
