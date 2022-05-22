extends Node

export var camera_path: NodePath 
export var camera_speed_multiplier : int = 1;
export var camera_speed : int =  20;

#func _input(event):
#	handle_camera_debug();
#
#func handle_camera_debug():
#	if camera_path == null:
#		return
#
#	var camera = get_node(camera_path);
#
#	if Input.is_action_pressed("ui_left"):
#		camera.position.x -= camera_speed * camera_speed_multiplier;
#
#	if Input.is_action_pressed("ui_down"):
#		camera.position.y += camera_speed * camera_speed_multiplier;
#
#	if Input.is_action_pressed("ui_right"):
#		camera.position.x += camera_speed * camera_speed_multiplier;
#
#	if Input.is_action_pressed("ui_up"):
#		camera.position.y -= camera_speed * camera_speed_multiplier;
#
