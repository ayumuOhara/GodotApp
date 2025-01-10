extends Node2D


@export var n_player :Area2D
@export var n_enemy_anchor : Node2D
@export var n_camera : Camera2D
@export var n_hud : CanvasLayer
var is_playing : bool
var score : int

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_player!=null)
	assert(n_hud!=null)
	assert(n_enemy_anchor!=null)
	assert(n_camera!=null)
	while true:
		await game()

## ゲーム
func game():
	n_hud.init()
	new_game()
	await n_hud.wait_start_button()
	spawn_enemies()
	is_playing=true
	while is_playing:
		await Common.wait_sec(0.1)
		check_enemies_clear()
	Common.wait_sec(1)
	await n_hud.wait_game_over()

func new_game():
	score = 0
	n_hud.update_score(score)
	n_player.start()

## 敵群を全滅させたか?
func check_enemies_clear():
	if is_playing and get_tree().get_nodes_in_group("enemy").size()==0:
		spawn_enemies()

## 敵群を生成
func spawn_enemies():
	for x in range(9):
		for y in range(3):
			var px=x*(16+8)+24
			var py=16*4+y*16
			var pos=Vector2(px,py)
			var enemy=Common.create_enemy(pos)
			enemy.anchor=n_enemy_anchor
			enemy.died.connect(_on_enemy_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
## エネミーが死亡した
func _on_enemy_died(value):
	score += value
	n_hud.update_score(score)
	n_camera.add_trauma(0.5)

## プレーヤが死亡した
func _on_player_died():
	get_tree().call_group(Common.ENEMY_GROUP,"queue_free")
	is_playing=false
## シールド変更された
func _on_player_shield_changed(max_value,value):
	n_hud.update_shield(max_value,value)
