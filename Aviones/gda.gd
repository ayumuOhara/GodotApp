extends CanvasLayer
class_name Gda

@export var n_popup_panel : PopupPanel
@export var n_url_button : Button

func _ready():
	assert(n_popup_panel != null)
	assert(n_url_button != null)
	n_popup_panel.visible = false

func tween_in():
	n_popup_panel.visible = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(n_popup_panel, "position", Vector2i(0, 0), 1)
	n_url_button.grab_focus()

# URLボタンが押されたとき
func _on_url_pressed():
	OS.shell_open("https://gamedevargentina.com")
# returnボタンが押されたとき
func _on_return_pressed():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(n_popup_panel, "position", Vector2i(-320, 0), 1)
	tween.tween_callback(n_popup_panel.hide)

# GDAメニューがアクディブか?
func is_active():
	return n_popup_panel.visible
