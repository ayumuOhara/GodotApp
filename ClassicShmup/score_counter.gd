extends HBoxContainer

@export var n_digits : Array[TextureRect]

var digit_coords={
	"1": Vector2(0,0),
	"2": Vector2(8,0),
	"3": Vector2(16,0),
	"4": Vector2(24,0),
	"5": Vector2(32,0),
	"6": Vector2(0,8),
	"7": Vector2(8,8),
	"8": Vector2(16,8),
	"9": Vector2(24,8),
	"0": Vector2(32,8),
}
var digit_size = Vector2(8,8)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_digits.size()==8)
	for d in n_digits:
		assert(d!=null)
	# display_digits(76543211)

func display_digits(value:int):
	var str="%08d" % value
	for i in range(8):
		var d = str[i]
		var xy=digit_coords[d]
		n_digits[i].texture.region = Rect2(xy, digit_size)
