extends Button

export (bool) var is_easy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_button_up():
	Agent.easy_mode = is_easy
	get_tree().change_scene("res://src/Screens/Board.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
