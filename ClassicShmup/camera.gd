extends Camera2D

@export var decay = 0.85
@export var max_offset=Vector2(10, 10)
@export var max_roll=0.2

var trauma = 0.0 
var trauma_power =2

func add_trauma(amount):
	trauma = min(trauma+amount,0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma>0:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
