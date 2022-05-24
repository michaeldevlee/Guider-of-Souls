extends KinematicBody2D


onready var anim_player = get_node("AnimationPlayer")
export (int) var speed = 200
var ability_nodes = {
	Abilities.LIGHT: "Abilities/Light"
}
# TODO: show available abilities in UI
var available_abilities = []
var current_ability
var can_move : bool = true

var velocity = Vector2()

func _ready():
	initialize_signals()

func get_input():
	
	if velocity == Vector2():
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

func set_move_status(status : bool):
	can_move = status
	velocity = Vector2()

func toggle_ability():
	if not current_ability:
		return
	var ability = get_node(ability_nodes[current_ability])
	ability.visible = not ability.visible
	
# TODO: show ui message "<abilityName> ability gained!"
func add_ability(name):
	if not name in available_abilities:
		available_abilities.append(name)
		current_ability = name

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
