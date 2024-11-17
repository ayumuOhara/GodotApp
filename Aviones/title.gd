extends Node2D

@export var n_level_1_button : Button
@export var n_aviones : Sprite2D
@export var n_gda : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_level_1_button != null)
	assert(n_aviones != null)
	assert(n_gda != null)
	n_level_1_button.grab_focus()

func _process(delta):
	swing_avoin(delta)

var swing_velocity_w : float = 0.3 # ゆれ速度
var swing_angle : float = 0.0  # 角度

# Called every frame. 'delta' is the elapsed time since the previous frame.
func swing_avoin(delta):
	swing_angle += delta
	n_aviones.position.x += sin(swing_angle) * swing_velocity_w	

# Level1ボタンが押されたとき
func _on_level_1_pressed():
	Game.set_scene_result(Game.SCENE_NEXT)
# Exitボタンが押されたとき
func _on_exit_pressed():
	get_tree().quit()
# LogoGDAボタンが押されたとき
func _on_logo_gda_pressed():
	n_gda.tween_in()
