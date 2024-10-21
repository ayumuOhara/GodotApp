extends Node

@export var n_stream_players : Array[AudioStreamPlayer]

# SE番号の定義
enum SeId {
	BEEP,
	CLICK,
	HI_SCORE,
	POWER_UP,
	TREE_UP,
}

func play_se(id):
	if id < n_stream_players.size():
		n_stream_players[id].play()
