extends Area2D
# 変数
var falldown : bool = false
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed_y : float = 0.0
# ノード
var n_game
var n_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	n_game = al_game
	n_sound = al_sound
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# falldownなら 落下させる
	if falldown : 
		speed_y += gravity * delta
		position.y += speed_y * delta

# なにかと重なったとき
func _on_body_entered(body):
	if body.name=="Player":
		n_game.add_coin(1)
		n_sound.play_se(n_sound.SE_COIN)
		queue_free()
