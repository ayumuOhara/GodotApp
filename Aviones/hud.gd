extends CanvasLayer

@export var n_score: Label
@export var n_game_over: Label
@export var n_complete : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_score!=null)
	assert(n_game_over!=null)
	assert(n_complete!=null)

# スコア表示
func print_score(score):
	var str="Score : %d" % score
	n_score.text = str

# levelスタート
func start_level():
	n_game_over.hide()
	n_complete.hide()
	show()
# タイトルスタート
func start_title():
	hide()
# Game Overを表示
func show_game_over():
	n_game_over.show()
# Level Completeを表示
func show_complete():
	n_complete.show()
