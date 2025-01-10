extends Area2D

@export var speed = -250

## 開始処理
func start(pos):
	position=pos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
## 画面外に出た
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

## なにかと衝突した
func _on_area_entered(area):
	if area.is_in_group(Common.ENEMY_GROUP):
		area.explode()
		queue_free()
