extends Area2D

# instantiate時に接続される
signal felled

@export var n_shadow : Sprite2D
@export var n_anim : AnimatedSprite2D

var velocity : float = 30.0
var direction : Vector2 = Vector2.DOWN

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_anim!=null)
	assert(n_shadow!=null)
	n_anim.frame=0
	direction.x = randf_range(-0.9,0.9)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * velocity * delta
	if position.y > Game.get_player_position().y + Game.SCREEN_HEIGHT:
		queue_free()

# コリジョン有効か/無効化
func set_collision_active( is_active: bool):
	set_deferred("monitoring",is_active)
	set_deferred("monitorable",is_active)

# なにかが衝突した
func _on_area_entered(area):
	if area.is_in_group("bullet"):
		felled.emit()
	
	set_collision_active(false)
	n_anim.frame = 1
	n_anim.play("explode")
	n_shadow.hide()
	Sound.play_se(Sound.SE_EXPLOSION)

# アニメーション終了
func _on_animated_sprite_2d_animation_finished():
	queue_free()
