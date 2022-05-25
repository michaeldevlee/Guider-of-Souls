extends TextureRect
class_name SkillIcon

onready var hover = get_node("Hover")
onready var active_outline = get_node("Active")
onready var locked = get_node("Locked")

var is_active : bool = false
var unlocked : bool = false
var skill_name 

signal updated_status (status)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and unlocked:
		if event.pressed and event.button_index == 1:
			
			if is_active:
				update_active_status(true)
			else:
				update_active_status(false)
				
			emit_signal("updated_status", self)

func update_active_status(status : bool):
	is_active = status
	active_outline.visible = status

func _on_Area2D_mouse_entered():
	hover.set_visible(true)

func _on_Area2D_mouse_exited():
	hover.set_visible(false)
