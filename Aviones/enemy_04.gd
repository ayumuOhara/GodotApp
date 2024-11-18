extends Path2D

# instantiate時に接続される
signal felled

@export var n_follow : PathFollow2D
@export var n_area : Area2D
@export var n_shadow : Sprite2D
@export var n_anim : AnimatedSprite2D
@export var n_collision : CollisionShape2D

var progress_ratio : float = 0.0
var progress_speed : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_follow!=null)
	assert(n_area!=null)
	assert(n_anim!=null)
	assert(n_shadow!=null)
	assert(n_collision!=null)
	n_anim.frame=0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_ratio += progress_speed*delta
	if progress_ratio <1:
		n_follow.progress_ratio = progress_ratio
		n_area.position = n_follow.position
		var rot = n_follow.rotation+PI/2
		n_shadow.rotation = rot
		n_anim.rotation=rot
		n_collision.rotation=rot
	else:
		queue_free()

# コリジョン有効か/無効化
func set_collision_active( is_active: bool):
	n_area.set_deferred("monitoring",is_active)
	n_area.set_deferred("monitorable",is_active)

# なにかが衝突した
func _on_area_2d_area_entered(area):
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
