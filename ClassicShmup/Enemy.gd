extends Area2D

signal died

@export var n_anim : AnimationPlayer
@export var n_move_timer : Timer
@export var n_shoot_timer : Timer

var start_pos = Vector2.ZERO
var speed = 0
var anchor
var follow_anchor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_anim!=null)
	assert(n_move_timer!=null)
	assert(n_shoot_timer!=null)
## 開始処理
func start(pos):
	follow_anchor=false
	speed=0
	position=Vector2(pos.x, -pos.y)
	start_pos=pos
	var wait_time=randf_range(0.25, 0.55)
	await Common.wait_sec(wait_time)
	var tw=create_tween().set_trans(Tween.TRANS_BACK)
	tw.tween_property(self,"position:y",start_pos.y,1.4)
	await tw.finished
	follow_anchor=true
	n_move_timer.wait_time=randf_range(5,20)
	n_move_timer.start()
	start_shoot_timer()

## ShootTimer スタート
func start_shoot_timer():
	n_shoot_timer.wait_time=randf_range(4,20)
	n_shoot_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if follow_anchor:
		position = start_pos + anchor.position
	position.y += speed * delta
	if position.y > Common.screen_size.y + 32:
		start(start_pos)
## 爆発処理
func explode():
	speed = 0
	n_anim.play("explode")
	set_deferred("monitorable",false)
	died.emit(5)
	await n_anim.animation_finished
	queue_free()

## MoveTimer のタイムアウト
func _on_move_timer_timeout():
	speed = randf_range(75,100)
	follow_anchor=false
## ShootTimer のタイムアウト
func _on_shoot_timer_timeout():
	Common.create_enemy_bullet(position)
	start_shoot_timer()
