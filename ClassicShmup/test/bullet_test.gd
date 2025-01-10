extends Node2D

func _ready():
	var pos:Vector2=Common.screen_size/2
	while true:
		await wait_key()
		Common.create_player_bullet(pos)

# マウス左ボタン押下待ち
func wait_key():
	while true:
		await get_tree().create_timer(0.1).timeout
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			break
	while true:
		await get_tree().create_timer(0.1).timeout
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)==false:
			break
