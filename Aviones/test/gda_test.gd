extends Node

var n_gda : CanvasLayer
# Called when the node enters the scene tree for the first time.
func _ready():
	n_gda=get_node("GDA")
	while true:
		await wait_key()
		n_gda.tween_in()
		await wait_active(true)   # スライドインして
		await wait_active(false)  # スライドアウトする

#  GDAのis_active()がflag と等しくなるのを待つ
func wait_active(flag):
	while true:
		await get_tree().create_timer(0.1).timeout
		if n_gda.is_active()==flag:
			break;		

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
