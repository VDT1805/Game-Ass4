class_name ClientModel

extends Node

const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")
var room: colyseus.Room

#set up basic schema
class GameState extends colyseus.Schema:
	static func define_fields():
		var mySynchronizedProperty = "Hello world"
		return [
			colyseus.Field.new("mySynchronizedProperty", colyseus.STRING, mySynchronizedProperty),
			colyseus.Field.new("currentClient", colyseus.STRING, ""),
			colyseus.Field.new("is_x_turn", colyseus.BOOLEAN, true),
		]



func _ready():
	#set up client
	var client = colyseus.Client.new("ws://localhost:2567")
	var promise = client.join_or_create(GameState, "my_room")
	yield(promise, "completed")
	if promise.get_state() == promise.State.Failed:
		print("Failed")
		return
	var room: colyseus.Room = promise.get_result()
	room.on_message("server-message").on(funcref(self, "_on_server_message"))
	room.on_message("game-message").on(funcref(self, "_on_game_message"))
	room.on_message("client-request").on(funcref(self, "_on_client_request"))
	self.room = room
#	print(room.session_id,"myclient")
	var state: GameState = room.get_state()
#	state.listen('currentClient:change').on(funcref(self, "_on_client_change"))
#	state.listen('currentClient:replace').on(funcref(self, "_on_client_rep"))
	room.on_state_change.on(funcref(self, "_on_state"))
	Singleton.myclient = room.session_id

signal new_piece_placed

signal new_turn

signal is_o_turn

func _on_state(state):
	print(state.currentClient,"FDLO")
	emit_signal("new_turn",state.currentClient)

#log server message to console
func _on_server_message(data):
	print(data)
	
#log game message to console
func _on_game_message(data):
	print(data)
	emit_signal("new_piece_placed",data)
#	if (data == "x"):
#		globalturn = "x"		
#		emit_signal("is_x_turn")
#	elif (data == "o"):
#		globalturn = "o"
#		emit_signal("is_o_turn")
				
#log client request to console and place piece
func _on_client_request(data):
	print (data)
#	emit_signal("new_piece_placed",data)


func _on_piece_placed(pos,piece):
	var res: String = str(pos)+"_"+piece
	room.send("game-message",res)

func get_sessionid():
	return room.session_id
