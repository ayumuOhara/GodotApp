extends Area2D

signal shield_changed
signal died

@export var n_ship : Sprite2D
@export var n_fire_anim : AnimatedSprite2D
@export var n_ship_anim : AnimationPlayer
@export var n_shot_cooldown : Timer

@export var speed=150
@export var cooldown=0.25
@export var max_shield =10
var shield = max_shield

var can_shoot = true
var player_position_min : Vector2
var player_position_max : Vector2
var is_dead : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_fire_anim!=null)
	assert(n_ship_anim!=null)
	assert(n_shot_cooldown!=null)
	player_position_min = Vector2(8,8)
	player_position_max = Common.screen_size - Vector2(8,8)
	start()
## 開始処理
func start():
	show()
	var screensize=Common.screen_size
	position=Vector2(screensize.x/2, screensize.y - 64)
	set_shield( max_shield )
	n_shot_cooldown.wait_time=cooldown
	n_ship_anim.play("RESET")
	await Common.wait_sec(0)  # RESETアニメを確実に実行させる
	set_deferred("monitorable",true)
	is_dead=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dead:
		return
	
	var input = Input.get_vector("left","right","up","down")
	if input.x > 0:
		n_ship_anim.play("right")
		n_fire_anim.animation="right"	
	elif input.x <0:
		n_ship_anim.play("left")
		n_fire_anim.animation="left"	
	else:
		n_ship_anim.play("forward")
		n_fire_anim.animation="forward"	
	position += input * speed * delta
	position = position.clamp(player_position_min,player_position_max)
	
	if Input.is_action_pressed("shoot"):
		shoot()
## 弾撃ち
func shoot():
	if not can_shoot:
		return
	can_shoot=false
	n_shot_cooldown.start()
	var pos = position + Vector2(0,-8)
	Common.create_player_bullet(pos)
	var tween = create_tween().set_parallel(false)	
	tween.tween_property(n_ship,"position:y",1,0.1)	
	tween.tween_property(n_ship,"position:y",0,0.05)	
## シールドに加算
func add_shield(add):
	var value = shield + add
	set_shield(value)
## シールド値セット
func set_shield(value):
	shield= clamp(value,0,max_shield)
	shield_changed.emit(max_shield,shield)
	if shield <= 0:
		is_dead = true
		set_deferred("monitorable",false)
		await explode()
		died.emit()

## 爆発アニメ(終了待ち)
func explode():
	n_ship_anim.play("explode")
	await n_ship_anim.animation_finished

func _on_shot_cooldown_timeout():
	can_shoot=true

func _on_area_entered(area):
	if area.is_in_group(Common.ENEMY_GROUP):
		area.explode()
		var value = shield - max_shield / 3.0
		set_shield(value)
