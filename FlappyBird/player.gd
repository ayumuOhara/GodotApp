extends CharacterBody2D

signal game_over

@export var n_sprite : Sprite2D

const PLAYER_WIDTH = 64
const PLAYER_HEIGHT = 64

# 重力
const GRAVITY_POWER := 1000
# ジャンプ力
const JUMP_POWER := -400
var can_jump =true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	assert(n_sprite!=null)
	velocity=Vector2.ZERO

func _physics_process(delta):
	update_move(delta)
	update_collision(delta)
	update_anim(delta)
	# 画面外に出た背消滅
	if position.x < - PLAYER_WIDTH/2 or position.y > Game.SCREEN_HEIGHT + PLAYER_HEIGHT/2:
		game_over.emit()
	
# 移動の更新
func update_move(delta):
	velocity.y += GRAVITY_POWER *delta
	if can_jump and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_POWER
	
	if position.y<0:
		velocity.y=100
	if position.y>600-64:
		velocity.y=JUMP_POWER
# 当たり判定の更新
func update_collision(delta):	
	#move_and_collide(velocity*delta)	
	var collision = move_and_collide(velocity*delta)
	if collision != null:
		# 衝突したらギャンプできない
		can_jump=false
		# 左方向に吹き飛ばす
		velocity.x -= 300
		if position.y < collision.get_position().y:
			# ドカンより上にブレーヤがいる
			velocity.y =-300
		else:
			# ドカンより下にプレーヤがいる
			velocity.y = 300
		move_and_collide(velocity*delta)
# アニメーションの更新
func update_anim(delta):
	# 三項演算子 (velocity.y>=0)? 0: 1
	var frame = 0 if velocity.y>=0 else 1 
	
	# 吹っ飛び中は回転する
	if can_jump==false:
		n_sprite.rotation -= 10*delta
		frame = 2
	n_sprite.frame = frame
