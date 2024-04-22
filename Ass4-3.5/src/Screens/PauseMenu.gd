extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if Input.is_action_pressed("menu_pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused =value
	get_tree().paused = is_paused
	visible = is_paused
	


func _on_ResumeButton_pressed():
	self.is_paused = false
