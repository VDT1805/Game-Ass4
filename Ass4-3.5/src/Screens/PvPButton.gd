extends Button

export(bool) var vs_computer


func _on_button_up():
	Agent.vs_computer = vs_computer
	if !vs_computer:
		get_tree().change_scene("res://src/Screens/Board-PVP.tscn")
	else:
		get_tree().change_scene("res://src/Screens/Difficulty.tscn")
