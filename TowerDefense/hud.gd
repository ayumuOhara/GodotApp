extends CanvasLayer
class_name HUD

# キャラ生成シグナル
signal launch

@export var n_cost : Label
@export var n_score : Label
@export var n_you_win : Label
@export var n_you_lose : Label

func _ready():
	assert(n_cost!=null)
	assert(n_score!=null)
	assert(n_you_win!=null)
	assert(n_you_lose!=null)

# コストを表示
func print_cost( cost ):
	n_cost.text="%02dP" % cost

# スコアを表示
func print_score( value, max):
	n_score.text="%dP / %dP" % [value,max]

# 「勝利」を表示
func show_win():
	n_you_win.show()
# 「勝利」を消去
func hide_win():
	n_you_win.hide()
# 「敗北」を表示	
func show_lose():
	n_you_lose.show()
# 「敗北」を消去
func hide_lose():
	n_you_lose.hide()
# ボタンが押された
func _on_button_pressed():
	launch.emit()
