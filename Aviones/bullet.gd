extends Area2D

var velocity : float = 200.0
var direction : Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * velocity * delta
	if position.y< Game.get_player_position().y -160:
		queue_free()

# なにかが重なったとき
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		queue_free()
