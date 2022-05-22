extends KinematicBody2D

onready var anim_player = get_node("AnimationPlayer")

export (int) var speed = 200
var can_move : bool = true

var velocity = Vector2()

func _ready():
	initialize_signals()

func get_input():
	
	if velocity == Vector2():
		anim_player.play("Idle")
	
	if !can_move:
		return
	
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

func set_move_status(status : bool):
	can_move = status
	velocity = Vector2()

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
