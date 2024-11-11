extends CanvasLayer

var n_game

func _ready():
	n_game=al_game

# 入力イベント処理
func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			n_game.set_scene_result(n_game.Result.DONE)
			pass
	if event is InputEventKey and Input.is_key_label_pressed(KEY_ENTER):
			n_game.set_scene_result(n_game.Result.DONE)
			pass
