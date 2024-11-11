extends Node2D
class_name Main

@export var n_camera : Camera2D
@export var n_hud : CanvasLayer
var n_common
var n_sound

var player_castle : Node2D
var enemy_castle : Node2D

const CAMERA_DEFAULT_ZOOM=0.8
const CASTLE_DEFAULT_DISTANCE=450.0
const CASTLE_DISTANCE = 500.0

const LAUNCH_COST=50
const SCORE_LIMIT=100
const SCORE_SPEED=10

var score : float
var state : int
var player_soldier_reload =0.0
var enemy_soldier_timer =0.0

var castle_scene = preload("res://castle.tscn")
var soldier_scene=preload("res://soldier.tscn")
# ステータス
enum {
	ST_FIGHT,  # 戦い中
	ST_WIN,    # 勝利
	ST_LOSE,   # 敗北
}

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_camera!=null)
	assert(n_hud!=null)
	n_common=al_common
	n_sound=al_sound
	n_hud.print_cost(LAUNCH_COST)
	await game()
	get_tree().change_scene_to_file("res://main.tscn")

func game():
	state=ST_FIGHT
	score=0
	print_score()
	n_hud.hide_win()
	n_hud.hide_lose()
	player_castle=create_castle(true,Vector2(CASTLE_DISTANCE,0))
	enemy_castle=create_castle(false,Vector2(-CASTLE_DISTANCE,0))
	var zoom = CASTLE_DEFAULT_DISTANCE/CASTLE_DISTANCE * CAMERA_DEFAULT_ZOOM
	n_camera.zoom=Vector2(zoom,zoom)
	n_sound.play_bgm()
	# WIN/LOSE待ち
	while state==ST_FIGHT:
		await n_common.wait_sec(0.1)
	await n_common.wait_sec(3)
	# キー待ち
	while true:
		if Input.is_key_label_pressed(KEY_ENTER):
			break
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			break;
		await n_common.wait_sec(0.1)

func _process(delta):
	# リロード減算
	player_soldier_reload -=delta
	add_score( SCORE_SPEED*delta )
	enemy_soldier_timer += delta

# 城の生成
func create_castle(is_player,pos):
	var castle=castle_scene.instantiate()
	castle.init(is_player)
	castle.position=pos
	add_child(castle)
	castle.castle_damage.connect(_on_damage_castle)
	return castle

# 兵士の生成
func create_soldier(is_player,pos):
	var soldier=soldier_scene.instantiate()
	soldier.init(is_player)
	soldier.position=pos
	add_child(soldier)
	return soldier

# スコアに加算
func add_score(value:float):
	score = clamp(score + value,0,SCORE_LIMIT)
	print_score()
# スコア表示
func print_score():
	var value=floor(score)
	n_hud.print_score(value,SCORE_LIMIT)

func _on_hud_launch():
	if state != ST_FIGHT:
		return
	if player_soldier_reload >= 0:
		return
	if  score>=LAUNCH_COST:
		add_score(-LAUNCH_COST)
		var pos=player_castle.position
		var soldier=create_soldier(true,pos)
		player_soldier_reload=soldier.reload_time

# 兵士が城にダメージ与える
func _on_damage_castle( castle, soldier ):
	if state!=ST_FIGHT:
		return
	var dmg=n_common.calc_damage(soldier.attack,0)
	castle.damage(dmg)
	n_sound.play_se(Sound.SE_HIT)
	if castle.is_dead():
		if castle.is_player_side==false:
			state=ST_WIN			
			n_hud.show_win()
		else:
			state=ST_LOSE
			n_hud.show_lose()
		remove_lose_soldiers()

# 負け側の兵士を削除
func remove_lose_soldiers():
	get_tree().call_group("soldiers","remove_if_lose", state==ST_WIN)

# 敵生成タイマーの処理
func _on_enemy_timer_timeout():
	if state==ST_FIGHT:
		var pos=enemy_castle.position
		create_soldier(false,pos)
