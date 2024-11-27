extends Node2D

@export var n_player : CharacterBody2D
@export var n_hud : CanvasLayer
var dokan_scene=preload("res://dokan.tscn")

var create_timer : float
var is_game_over : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	#assert(n_caption!=null)
	assert(n_player!=null)
	assert(n_hud!=null)
	game()

func game():
	randomize()
	init()
	# READY 表示
	Game.pause(true)
	await n_hud.wait_ready()
	Game.pause(false)
	is_game_over=false
	# 終了待ち
	while is_game_over==false:
		await Game.wait_sec(0.1)
	# GAME OVER 表示
	await n_hud.wait_game_over()	
	get_tree().change_scene_to_file("res://main.tscn")

# 初期化
func init():
	Game.init()
	print_score()
	var pos=Vector2(Game.SCREEN_WIDTH/2, Game.SCREEN_HEIGHT/2)
	create_dokan_at(pos)
	create_timer = Game.dokan_create_interval / 2
	n_player.position=Vector2(Game.SCREEN_WIDTH/4,Game.SCREEN_HEIGHT/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ボーズか?
	if Input.is_action_pressed("pause"):
		# ボーズ解除を待つ
		Game.pause(true)
		await n_hud.wait_pause()
		Game.pause(false)
		return
	
	create_timer += delta
	if create_timer > Game.dokan_create_interval:
		create_timer -= Game.dokan_create_interval
		create_dokan()

# ドカン生成
#  ------------------------- 0
#       |   |            --- MARGIN
#       +---+            ---
#                         ↑
#                         ↓  dokan_between_space
#       +---+            ---
#       |   |            --- MARGIN
#  ------------------------- SCREEN_HEIGHT
func create_dokan():
	var x = Game.SCREEN_WIDTH + Game.DOKAN_WIDTH/2
	const MARGIN = 32
	var min = MARGIN + Game.dokan_between_space/2
	var max = Game.SCREEN_HEIGHT - min
	var y = randf_range(min,max)
	create_dokan_at(Vector2(x,y))
	Game.add_dokan_count()
	print_score()

# 位置指定のドカン生成	
func create_dokan_at(pos:Vector2):
	var DOKAN_HALF_HEI = Game.DOKAN_HEIGHT/2
	
	var y=pos.y
	for i in range(2):
		var dokan=dokan_scene.instantiate()
		if i==0 :
			pos.y = y - DOKAN_HALF_HEI - Game.dokan_between_space/2
		else:
			pos.y = y + DOKAN_HALF_HEI + Game.dokan_between_space/2
		
		dokan.start(pos,Game.dokan_speed)
		add_child(dokan)

# スコア表示
func print_score():
	n_hud.print_score(Game.dokan_count)

# playerのゲームオーバシグナル
func _on_player_game_over():
	is_game_over=true
	Game.pause(true)
