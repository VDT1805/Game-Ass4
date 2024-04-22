# class name and extends
extends Node


# dictionaries and variables
var stats = {}
var visited_nodes: = 0
var vs_computer: = true

# functions
func alpha_beta_search(state: Model, depth: int, alpha, beta, is_max: bool) -> Array:
	visited_nodes += 1
	if state.is_game_over() or depth == 0:
		var utility: = get_utility(state, depth)
		return [-1, utility]
	var best_value: Array
	if is_max:
		best_value = [-1, -INF]
	else:
		best_value = [-1, INF]

	for move in get_next_moves(state):
		var cell: Area2D = state.board[move]
		state.make_move(cell, is_max, true)
		var value: Array = [move, alpha_beta_search(state, depth-1, alpha, beta, not is_max)[1]]
		state.undo_move(cell)
		if is_max:
			best_value = max_array(value, best_value, 1)
			alpha = max(alpha, best_value[1])
			if alpha >= beta:
				break # return [move,alpha]
		else:
			best_value = min_array(value, best_value, 1)
			beta = min(beta, best_value[1])
			if alpha >= beta:
				break # return [move,beta]
	return best_value

func move(state: Model, player: bool) -> int:
	var start_time: = OS.get_ticks_msec()
	var move: int = alpha_beta_search(state, get_next_moves(state).size(), -INF, INF, player)[0]
	print_stats(start_time)
	return move

func get_utility(state: Model, depth: int) -> int:
	return state.get_score() - depth

func get_next_moves(state: Model) -> Array:
	return state.get_empty_tiles()

func min_array(first: Array, second: Array, pos: int) -> Array:
	if first[pos] < second[pos]:
		return first
	else:
		return second

func max_array(first: Array, second: Array, pos: int) -> Array:
	if first[pos] > second[pos]:
		return first
	else:
		return second

func print_stats(start_time: int) -> void:
	stats.elapsed_time = str(OS.get_ticks_msec() - start_time) + " ms"
	stats.nodes = visited_nodes
	visited_nodes = 0
	print("STATS:\n", stats)
