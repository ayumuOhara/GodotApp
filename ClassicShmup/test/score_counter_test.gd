extends Node

var ScoreCounter : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreCounter = get_node("ScoreCounter")
	var score:int
	var add:int
	while true:
		await wait_key()
		var exp=randi_range(0,7)
		add=10 ** exp  ## ** はべき乗
		score=randi_range(0,99999999)
		print("score:%08d"%score)
		ScoreCounter.display_digits(score)
		for i in range(10):
			await wait_key()
			score += add
			print("score:%08d"%score)
			ScoreCounter.display_digits(score)

# マウス左ボタン押下待ち
func wait_key():
	while true:
		await get_tree().create_timer(0.1).timeout
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			break
	while true:
		await get_tree().create_timer(0.1).timeout
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)==false:
			break
