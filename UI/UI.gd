extends CanvasLayer

onready var main_UI = get_node("Main UI Container")
onready var anim_player = get_node("AnimationPlayer")
onready var skills_container = get_node("Main UI Container/VBoxContainer/HBoxContainer")

var skill_icons = []

func _ready():
	register_signals()
	
	for skill in skills_container.get_children():
		skill.connect("updated_status", self, "update_current_skill")
		skill_icons.append(skill)
		
		if skill.unlocked == false:
			skill.locked.set_visible(true)

func update_current_skill(skill_icon : SkillIcon):
	
	if skill_icon:
		var active_index = skill_icons.find(skill_icon)
		var active_icon = skill_icons[active_index]
		
		for skill in skill_icons:
			if skill == active_icon:
				skill.update_active_status(true)
			else:
				skill.update_active_status(false)

func update_new_skill(name):
	for skill in skill_icons:
		if skill.unlocked == false:
			skill.unlocked = true
			skill.locked.set_visible(false)
			skill.update_active_status(true)
			skill.skill_name = name
			print(skill.skill_name)
			return
			

func _on_Hover_mouse_entered():
	anim_player.play("Slide")

func _on_Hover_mouse_exited():
	anim_player.play_backwards("Slide")

func register_signals():
	UiManager.connect("update_skills", self, "update_new_skill")