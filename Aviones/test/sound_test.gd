extends Node

var Sound : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Sound = get_node("Sound")
	while true:
		await wait_key()
		Sound.play_bgm(Sound.BGM_TITLE)
		await wait_key()
		Sound.play_bgm(Sound.BGM_LEVEL)
		await wait_key()
		Sound.stop_bgm()
		await wait_key()
		Sound.play_se(Sound.SE_SHOT)
		await wait_key()
		Sound.play_se(Sound.SE_EXPLOSION)
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
