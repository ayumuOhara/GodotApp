extends CharacterBody2D

var n_sound 
var n_game

@export var move_speed : int
@export var can_tread : bool
@export var n_sprite : Sprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	n_sound=get_node("/root/ai_sound")
	n_game=get_node("/root/ai_game")
	n_sprite.flip_h = (move_speed<0)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = move_speed
	move_and_slide()

# WeakAreaになにかが重なった
func _on_weak_area_body_entered(body):
	if body.name == "Player" and can_tread:
		n_sound.play_se(n_sound.SE_HIT)
		queue_free()

# AtttackAreaになにかが重なった
func _on_attack_area_body_entered(body):
	if body.name == "Player":
		n_game.damage(20)
		if n_game.is_player_dead()==false :
			body.knockback()
