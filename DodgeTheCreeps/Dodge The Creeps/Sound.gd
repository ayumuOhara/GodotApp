extends Node

var n_bgm
var n_game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	n_bgm = get_node("BGM")
	n_game_over = get_node("GameOver")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_bgm():
	n_bgm.play()

func stop_bgm():
	n_bgm.stop()

func play_game_over():
	n_game_over.play()
