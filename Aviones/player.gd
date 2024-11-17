extends Area2D
class_name Player

signal level_complete
signal game_over

@export var n_shadow : Sprite2D
@export var n_anim : AnimatedSprite2D
@export var n_shot_disable_timer : Timer

const CANNON_OFFS : Vector2 =Vector2(0,20)  # 砲頭オフセット
const SCROLL_ADVANCE: Vector2 = Vector2(0,-0.5)  # スクロール前進ベクトル
const FINISH_LEVEL : float = -2800.0 # レベルの終了位置(y)
const SIDE_MARGIN : float = 16.0
var speed : float = 70.0
var can_shot : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_anim!=null)
	assert(n_shadow!=null)
	assert(n_shot_disable_timer!=null)
	n_shadow.show()
	n_anim.frame = 0
	n_anim.stop()
	set_collision_active(true)
	Game.set_player(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.is_play_out:
		return
	# 自機移動
	var direction=Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y = -0.5
	if Input.is_action_pressed("ui_down"):
		direction.y = 0.2
	if Input.is_action_pressed("ui_left") and position.x > SIDE_MARGIN:
		direction.x = -1
	if Input.is_action_pressed("ui_right") and position.x < Game.SCREEN_WIDTH - SIDE_MARGIN:
		direction.x = 1
	position += (direction + SCROLL_ADVANCE) * speed * delta
	# ショット
	if Input.is_action_pressed("ui_accept") and can_shot:
		n_shot_disable_timer.start()
		can_shot = false
		shoot()
	# マップ終わり?
	if position.y <= FINISH_LEVEL:
		Game.set_play_out()
		can_shot = false
		set_collision_active(false)
		level_complete.emit()

# 弾発射
func shoot():
	var pos = global_position - CANNON_OFFS
	Game.create_bullet(pos)
	Sound.play_se(Sound.SE_SHOT)

# コリジョン有効か/無効化
func set_collision_active( is_active: bool):
	set_deferred("monitoring",is_active)
	set_deferred("monitorable",is_active)

# 自機になにかが衝突した
func _on_area_entered(area):
	if Game.is_play_out:
		return
	if area.is_in_group("enemy"):
		Game.set_play_out()
		set_collision_active(false)
		n_anim.frame = 1
		n_anim.play("explode")
		n_shadow.hide()
		Sound.play_se(Sound.SE_EXPLOSION)
		can_shot = false

# 爆発アニメが終了した
func _on_animated_sprite_2d_animation_finished():
	game_over.emit()

# 射撃禁止タイマーがタイムアウト
func _on_shot_disable_timer_timeout():
	can_shot=true
