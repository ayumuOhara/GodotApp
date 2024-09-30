extends Area2D

signal hit

@export var speed = 400  # 移動速度(ピクセル/秒)
var screen_size  # スクリーンサイズ
var anim : AnimatedSprite2D
var collision : CollisionShape2D
var isjump : bool = false
var n_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	anim = get_node("AnimatedSprite2D")
	collision = get_node("CollisionShape2D")
	n_sound = get_node("Sound")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isjump == false :
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


func _on_hit():
	pass # Replace with function body.

func _on_jump_button_pressed():
	if isjump == false:
		isjump = true
		n_sound.play_jump()
		collision.set_deferred("disabled",true)
		scale += Vector2(0.2,0.2)
		await wait_sec(1.5)
		scale += Vector2(-0.2,-0.2)
		isjump = false
		collision.set_deferred("disabled",false)

	
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout
