extends Node

var Hud : CanvasLayer

func _ready():
	Hud=get_node("HUD")
	while true:
		await wait_key()
		Hud.start_title()
		await wait_key()
		Hud.start_level()
		await wait_key()
		var score=randi_range(0,100)
		Hud.print_score(score)
		await wait_key()
		Hud.show_game_over()
		await wait_key()
		Hud.start_level()
		Hud.show_complete()

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
	pass # Replace with function body.
