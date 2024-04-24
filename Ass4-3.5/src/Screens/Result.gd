extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ResTitle.set_text(Singleton.winner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AgainButton_button_up():
	get_tree().change_scene("res://src/Screens/Main.tscn")
