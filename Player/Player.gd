extends KinematicBody2D
class_name Player


onready var anim_player = get_node("AnimationPlayer")
export (int) var speed = 200

var available_abilities = []
var current_ability
var currently_in_event : bool = false

var can_move : bool = true
var can_interact : bool = false
var can_teleport : bool = false
var can_push : bool = false
var interaction_object = null
var direction
var prev_grab_sprite
var curr_grab_sprite

var velocity = Vector2()

func _ready():
	initialize_signals()

func get_input():
	if velocity == Vector2() and !currently_in_event:
		anim_player.play("Idle")
	
	if !can_move:
		return
	
	if Input.is_action_pressed("switch_ability"):
		switch_ability()
	
	if Input.is_action_pressed("use_ability"):
		toggle_ability()
	
	velocity = Vector2()
	update_grab_sprite()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = "right"
		curr_grab_sprite = $"Abilities/Grab/Right"
		anim_player.play("Walk Right")
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = "left"
		curr_grab_sprite = $"Abilities/Grab/Left"
		anim_player.play("Walk Left")
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = "down"
		curr_grab_sprite = $"Abilities/Grab/Down"
		anim_player.play("Walk Down")
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = "up"
		curr_grab_sprite = $"Abilities/Grab/Up"
		anim_player.play("Walk Up")
	
	velocity = velocity.normalized() * speed
	if can_push && get_slide_count() > 0:
		check_box_collision(velocity)

func switch_ability():
	if available_abilities.size() < 1:
		return
	if available_abilities[-1] == current_ability:
		current_ability = available_abilities[0]
	else:
		var prev = available_abilities.find(current_ability)
		current_ability = available_abilities[prev + 1];


func check_box_collision(velocity):
	var box = get_slide_collision(0).collider as Box
	if box:
		box.push(velocity * .5);

func initialize_signals():
	EventBus.connect("update_player_move_status", self, "set_move_status")
	EventBus.connect("add_ability", self, "add_ability")
	UiManager.connect("update_current_ability", self, "update_current_ability")

func set_move_status(status : bool):
	can_move = status
	velocity = Vector2()
	
func use_light():
	var ability = $Abilities/Light
	ability.visible = not ability.visible
	
func use_push():
	if current_ability == Abilities.PUSH:
		can_push = true
	else:
		can_push = false
	
func get_raycast_direction():
	if direction == "down":
		return Vector2(0, 5000)
	elif direction == "up":
		return Vector2(0, -5000)
	elif direction == "right":
		return Vector2(5000, 0)
	elif direction == "left":
		return Vector2(-5000, 0)

func update_grab_sprite():
	if current_ability == Abilities.GRAB:
		if prev_grab_sprite:
			prev_grab_sprite.visible = false
		if curr_grab_sprite:
			curr_grab_sprite.visible = true
		prev_grab_sprite = curr_grab_sprite

func use_grab():
	var ability = $GrabRayCast2D
	ability.enabled = true
	ability.cast_to = get_raycast_direction()
	if ability.is_colliding():
		ability.get_collider().on_collide(position)

func toggle_ability():
	if not current_ability:
		return
	if(current_ability == Abilities.LIGHT):
		use_light()
	elif(current_ability == Abilities.GRAB):
		use_grab()

	
func add_ability(name):
	if not name in available_abilities:
		can_move = false
		currently_in_event = true
		AudioManager.play_SFX(Sfx.get_ability, 1.5)
		yield(player_gained_ability_anim(),"completed")
		currently_in_event = false
		available_abilities.append(name)
		DialogueManager.emit_signal("dialogue_started", Abilities.abilities_gained_text_list[name])
		UiManager.emit_signal("update_skills", name)
		DialogueManager.player_ready_for_dialogue = true
		update_current_ability(name)

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
	
	if area.is_in_group("Portal"):
		interaction_object = area.owner
		can_teleport = true

func _on_Interact_Area_area_exited(area):
	DialogueManager.player_ready_for_dialogue = false
	can_teleport = false
	interaction_object = null

func _input(event):
	if Input.is_action_just_pressed("interact") and interaction_object:
		if DialogueManager.player_ready_for_dialogue:
			interaction_object.initiate_conversation()
		if can_teleport:
			interaction_object.teleport(self)
