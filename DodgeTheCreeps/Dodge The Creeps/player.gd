extends Area2D

signal hit

@export var speed = 400  # 移動速度(ピクセル/秒)
var screen_size  # スクリーンサイズ
var anim : AnimatedSprite2D
var collision : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	anim = get_node("AnimatedSprite2D")
	collision = get_node("CollisionShape2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 速度ペクトル
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	# 速度ペクト*スピード
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		anim.play()
	else:
		anim.stop()
	# 位置を更新
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size);
	# アニメパターン修正
	if velocity.x != 0:
		anim.animation = "walk"
		anim.flip_h = (velocity.x < 0)
	elif velocity.y != 0:
		anim.animation = "up"
		anim.flip_v = (velocity.y > 0)

func _on_body_entered(body):
	hide()  # playerを消す
	hit.emit() # hit シグナル発行→上位で処理
	# シグナル処理中は、物理プロパティ変更できないので、遅延処理する. 
	collision.set_deferred("disabled",true) #コリジョン無効化

func start(pos):
	position=pos
	show()
	collision.disabled=false
