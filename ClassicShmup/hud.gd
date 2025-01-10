extends CanvasLayer

@export var n_shield_bar : TextureProgressBar
@export var n_score_counter : HBoxContainer
@export var n_game_over : TextureRect
@export var n_start_button : TextureButton

func _ready():
	assert(n_shield_bar!=null)
	assert(n_score_counter!=null)
	assert(n_game_over!=null)
	assert(n_start_button!=null)

## 初期化
func init():
	n_game_over.hide()
	n_start_button.hide()
	update_score(0)
	update_shield(100,100)
	
## スコア更新
func update_score(score):
	n_score_counter.display_digits(score)
## シールドバー更新
func update_shield(max_value, value):
	n_shield_bar.value = value
	n_shield_bar.max_value = max_value

## STARTボタンが押されるのを待つ
func wait_start_button():
	n_start_button.show()
	await n_start_button.pressed
	n_start_button.hide()
## GameOver 表示して数秒待つ	
func wait_game_over():
	n_game_over.show()
	await Common.wait_sec(2)
	n_game_over.hide()
