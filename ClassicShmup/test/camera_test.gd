extends Node2D

var camera:Camera2D

func _ready():
	camera=get_node("Camera")
	while true:
		await wait_key()
		camera.add_trauma(0.5)

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
