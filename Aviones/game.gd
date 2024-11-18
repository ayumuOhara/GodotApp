extends Node

var bullet_scene : PackedScene = preload("res://bullet.tscn")
var enemy_scene : Array[PackedScene]=[
preload("res://enemy_01.tscn"),
preload("res://enemy_02.tscn"),
preload("res://enemy_03.tscn"),
preload("res://enemy_04.tscn"),
]
# エネミー種別
enum{
	ENEMY_01,
	ENEMY_02,
	ENEMY_03,
	ENEMY_04,
}
# ノード
var n_player : Node2D

var score :int =0              # スコア
var is_play_out : bool =false  # プレイ終了
var level_difficulty           # レベル難易度
var scene_result               # シーン結果(リザルト)
# 定数
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 240
# シーン結果
enum{
	SCENE_NONE,
	SCENE_NEXT,
}

func _ready():
	while true: ###　あとで trueに差し替えます
		n_player=null
		await game()

func game():
	score=0
	Hud.print_score(score)
	level_difficulty=0
	is_play_out = false
	Hud.start_title()
	Sound.play_bgm(Sound.BGM_TITLE)
	await exec_scene("res://title.tscn")
	Hud.start_level()
	Sound.play_bgm(Sound.BGM_LEVEL)
	await exec_scene("res://level.tscn")

# シーンの実行
func exec_scene(scene_path):
	scene_result=SCENE_NONE
	get_tree().change_scene_to_file(scene_path)
	while scene_result==SCENE_NONE:
		await wait_sec(0.1)
# シーン結果をセット
func set_scene_result(result):
	scene_result = result

# 弾を生成
func create_bullet(pos):
	var bullet = bullet_scene.instantiate()
	bullet.global_position=pos
	get_tree().root.add_child(bullet)
# 敵を生成
func create_enemy(id,pos,parent_node):
	if 0<=id and id <enemy_scene.size():
		var enemy = enemy_scene[id].instantiate()
		enemy.felled.connect(add_score)
		enemy.position = pos
		parent_node.add_child(enemy)
# スコア加算
func add_score():
	score += 1
	Hud.print_score(score)
# レベル難易度を加算
func add_difficulty():
	level_difficulty += 1

# プレーヤのインスタンスをセット
func set_player(player):
	self.n_player=player

# sec秒待ち
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout
# プレイ終了
func set_play_out():
	is_play_out=true
# プレーヤの位置取得
func get_player_position():
	if n_player==null:
		return Vector2(160,120)
	return n_player.position
