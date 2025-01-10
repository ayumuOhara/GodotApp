extends Control

var hud : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_node("HUD")
	while true:
		hud.init()
		await wait_key()
		await test_score()
		await wait_key()
		await test_shield()
		await hud.wait_start_button()
		await hud.wait_game_over()
		
## スコアのテスト
func test_score():
	var score:int=0
	for i in range(8):
		var add:int=10**i  ## ** はべき乗
		for j in range(9):
			score+=add
			hud.update_score(score)
			await Common.wait_sec(0.1)
## シールドバーのテスト
func test_shield():
	const max=100
	for i in range(max):
		hud.update_shield(max,i+1)
		await Common.wait_sec(0.1)
	for i in range(max):
		hud.update_shield(max,max-i)
		await Common.wait_sec(0.1)

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
