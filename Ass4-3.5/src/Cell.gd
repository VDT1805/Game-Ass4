extends Area2D

signal clicked
signal focus

var value: = 0
var chosen: = false

func _ready():
	pass

func _on_mouse_entered():
	if not chosen:
		Input.set_default_cursor_shape(2)
		emit_signal("focus", self)
		$Focus.visible = true

func _on_mouse_exited():
	Input.set_default_cursor_shape(0)
	$Focus.visible = false

func _on_input_event(_viewport, event, _shape_idx):
	if not chosen:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				emit_signal("clicked", self)
