extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops().set_parallel(false).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", position.x + 3, 1.0)
	tween.tween_property(self, "position:x", position.x - 3, 1.0)
	var tween2 = create_tween().set_loops().set_parallel(false).set_trans(Tween.TRANS_BACK)
	tween2.tween_property(self, "position:y", position.y + 3, 1.5).set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(self, "position:y", position.y - 3, 1.5).set_ease(Tween.EASE_IN_OUT)
