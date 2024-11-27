extends StaticBody2D

var velocity : Vector2

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	if position.x < -Game.DOKAN_WIDTH/2:
		queue_free()

# 開始処理
func start(pos,speed):
	position=pos
	velocity = Vector2(-speed,0)
