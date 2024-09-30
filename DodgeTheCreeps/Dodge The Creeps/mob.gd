extends RigidBody2D

var n_anim : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	n_anim = get_node("AnimatedSprite2D")
	# アニメ名前配列を取得
	var mob_types = n_anim.sprite_frames.get_animation_names()
	# アニメのランダム選択してプレイ
	var idx=randi() % mob_types.size()
	n_anim.play(mob_types[idx]);

# VisubleOnScreenNotifier2D の screen_exited シグナルの処理
# 画面外に出たら消す
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
