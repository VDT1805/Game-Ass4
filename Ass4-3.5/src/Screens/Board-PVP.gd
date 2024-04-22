class_name ModelPVP
extends Node2D


onready var cross: = preload("res://asset/x.png")
onready var circle: = preload("res://asset/o.png")
onready var cross_grey: = preload("res://asset/x_grey.png")
onready var circle_grey: = preload("res://asset/o_grey.png")

var is_x_turn: = true
var board_size: = 9
var empty_cells: = board_size
export(int) var width: = 3
export(int) var height: = 3
var board: = []
# TODO: use only one board structure
var matrix_board: = []
var currentTurn: String
signal piece_placed

func _on_turn_changed(newTurn):
	print(newTurn,"changed")
	currentTurn = newTurn
# _init() and _ready()
func _ready():
	for _x in width:
		matrix_board.append([])
	var row: = 0
	var column: = 0
	for cell in get_tree().get_nodes_in_group("cells"):
		cell.connect("clicked", self, "on_cell_clicked")
		cell.connect("focus", self, "on_cell_focus")
		board.append(cell)
		matrix_board[row].append(cell)
		column += 1
		if column == width:
			row += 1
			column = 0


# functions
func play(cell: Area2D, index: int) -> void:
	if Singleton.myclient == currentTurn:
		make_move(cell, is_x_turn)
		emit_signal("piece_placed", index, "X" if is_x_turn else "O")
		var result: = check_victory(index)
		if result != 0 or empty_cells == 0:
			end_game(result)
		is_x_turn = not is_x_turn
	


func make_move(cell: Area2D, is_player_x: bool) -> void:
	var cell_sign: = cell.get_node("Sign")
	var cell_focus: = cell.get_node("Focus")
	if is_player_x:
		cell.value = 1
		cell_sign.texture = cross
	else:
		cell.value = -1
		cell_sign.texture = circle
	cell_sign.visible = true
	cell_focus.visible = false
	cell.chosen = true
	empty_cells -= 1


## Add this function
#func _on_place_piece(position, pieceType):
#	# Place the piece
#	board[position] = pieceType
#
#	# Update the UI
#	update_ui()
#
#	# Notify Client.gd
#	emit_signal("piece_placed", position, pieceType)

#func update_ui():
#	for i in range(width):
#		for j in range(height):
#			var cell = matrix_board[i][j]
#			if board[i * width + j] == 1:
#				cell.texture = cross
#			elif board[i * width + j] == -1:
#				cell.texture = circle
#			else:
#				cell.texture = null

#func undo_move(cell: Area2D) -> void:
#	cell.value = 0
#	cell.chosen = false
#	empty_cells += 1

func check_victory(index: int) -> int:
	var x: = index / width
	var y: = index % width
	
	#check if previous move caused a win on vertical line 
	if matrix_board[0][y].value == matrix_board[1][y].value and matrix_board[1][y].value == matrix_board [2][y].value:
		return matrix_board[0][y].value
	#check if previous move caused a win on horizontal line 
	if matrix_board[x][0].value == matrix_board[x][1].value and matrix_board[x][1].value == matrix_board [x][2].value:
		return matrix_board[x][0].value
	#check if previous move was on the main diagonal and caused a win
	if x == y and matrix_board[0][0].value == matrix_board[1][1].value and matrix_board[1][1].value == matrix_board [2][2].value:
		return matrix_board[0][0].value
	#check if previous move was on the secondary diagonal and caused a win
	if x + y == 2 and matrix_board[0][2].value == matrix_board[1][1].value and matrix_board[1][1].value == matrix_board [2][0].value:
		return matrix_board[0][2].value
	# else
	return 0

func is_game_over() -> bool:
	if get_score() != 0 or empty_cells <= 0:
		return true
	else:
		return false

func get_empty_tiles() -> Array:
	var _tiles: Array
	for i in board_size:
		if not board[i].chosen:
			_tiles.append(i)
	return _tiles

func get_score() -> int:
	var score: int
	for index in board_size:
		score = check_victory(index)
		if score != 0: # someone has won
			break
	return score * (board_size + 1)

func end_game(value: int) -> void:
	if value == 1:
		print("X win!!")
	elif value == -1:
		print("O win!!")
	else: # value == 0
		print("It's a tie!")
	get_tree().change_scene("res://src/Screens/Main.tscn")


#signal functions
func on_cell_focus(cell: Area2D):
	if is_x_turn:
		cell.get_node("Focus").texture = cross_grey
	else:
		cell.get_node("Focus").texture = circle_grey

func on_cell_clicked(cell: Area2D):
	var index: = board.find(cell)
	play(cell, index)

func _on_new_piece_placed(data):
	var splitdata: Array = data.split("_")
	var cell: Area2D = get_tree().get_nodes_in_group("cells")[int(splitdata[0])]
	var cell_sign: = cell.get_node("Sign")
	var cell_focus: = cell.get_node("Focus")
	if splitdata[1] == "X":
		cell.value = 1
		cell_sign.texture = cross
	else:
		cell.value = -1
		cell_sign.texture = circle
	cell_sign.visible = true
	cell_focus.visible = false
	cell.chosen = true
	empty_cells -= 1
	var result: = check_victory(int(splitdata[0]))
	if result != 0 or empty_cells == 0:
		end_game(result)
	is_x_turn = not is_x_turn
	
