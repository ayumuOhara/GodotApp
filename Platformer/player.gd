extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var n_collision : CollisionShape2D
@export var n_anim : AnimatedSprite2D
@export var n_camera : Camera2D
var n_sound 
var n_game
var al_sound
var al_game

# ステート値
enum {
	ST_STAND,
	ST_FALL,
	ST_LAND,
}

var state : int
var can_move : bool
var is_fall_motion : bool

func _ready():
	n_sound=al_sound
	n_game =al_game
	n_game.set_player(self)
	state = ST_STAND
	can_move = true
	n_anim.set_position(Vector2.ZERO)
	n_anim.show()
	n_collision.disabled = false
	is_fall_motion=false

func _physics_process(delta):
	if is_fall_motion:
		return
	# Add the gravity.
	if not is_on_floor():
		state=ST_FALL
		velocity.y += gravity * delta
		if velocity.y > 0.0:
			n_anim.play("fall")
		else:
			n_anim.play("jump")
	else:
		if state==ST_FALL:
			state = ST_LAND
			n_anim.play("land",4.0)
			await n_anim.animation_looped
			state=ST_STAND
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		n_sound.play_se(n_sound.SE_JUMP)
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if can_move==false:
		pass
	elif direction != 0:
		n_anim.flip_h= (direction == -1)
		if state == ST_STAND:
			n_anim.play("walk")
		velocity.x = direction * SPEED
	else:
		if state==ST_STAND:
			n_anim.play("idle")
		velocity.x = move_toward(velocity.x,0,SPEED)

	move_and_slide()
	# 画面サイズより下にいったら
	var screen_size=get_viewport_rect().size
	if position.y >=screen_size.y:
		await fall_motion(velocity)
		await n_game.wait_sec(2)
		n_game.set_scene_result(n_game.Result.GAME_OVER)

# ノックバック処理
func knockback():
	can_move=false
	if n_anim.flip_h == true:
		velocity= Vector2(100,-300)
	else:
		velocity=Vector2(-100,-300)
	await get_tree().create_timer(0.5).timeout
	can_move=true

# 死亡モーション
func dead_motion():
	await fall_motion(Vector2(0,-300))

# 落下モーション
func fall_motion(vector:Vector2):
	# 落下中は、move_and_slide()させない
	is_fall_motion=true
	# コリジョン禁止
	n_collision.disabled=true
	const delta=0.02
	var screen_rect :Rect2 =get_viewport_rect()
	var center = n_camera.get_screen_center_position()
	screen_rect.position = center - screen_rect.size/2
	while screen_rect.has_point(n_anim.global_position):
		await n_game.wait_sec(delta)
		velocity.y += gravity * delta
		n_anim.position += velocity * delta
	n_anim.hide()
