extends Node

const HP_MAX=100
var hp :int
var coin : int
var scene_result
# ノード
var n_hud
var n_sound
var n_player
# シーンID
enum Scene{
	GAME_START,
	STAGE_1,
	GAME_OVER,
	GAME_CLEAR,
}
# シーン結果
enum Result{
	NONE,
	DONE,
	GAME_OVER,
	GAME_CLEAR,
}

func main():
	while true:
		await game()

func game():		
	#== ゲーム初期化
	hp=HP_MAX
	coin=0
	n_hud.set_health_max(HP_MAX)
	n_hud.set_health(hp)
	n_hud.set_coin(coin)
	#== スタート画面
	n_hud.hide()
	await exec_scene(Scene.GAME_START)
	#== ゲーム画面
	n_sound.play_bgm()
	n_hud.show()
	await exec_scene(Scene.STAGE_1)
	n_hud.hide()
	n_sound.stop_bgm()
	#== ゲームオーバ画面またはゲームクリア画面
	if scene_result==Scene.GAME_CLEAR:
		await exec_scene(Scene.GAME_CLEAR)
	else:
		await exec_scene(Scene.GAME_OVER)

# シーンを実行
func exec_scene(id):
	var scene_path
	match(id):
		Scene.GAME_START:
			scene_path="res://game_start.tscn"
		Scene.GAME_OVER:
			scene_path="res://game_over.tscn"
		Scene.GAME_CLEAR:
			scene_path="res://game_clear.tscn"
		Scene.STAGE_1:
			scene_path="res://stage_1.tscn"

	scene_result=Result.NONE
	# print("before change scene(%s)\n"%scene_path)
	get_tree().change_scene_to_file(scene_path)
	# print("after change scene(%s)\n"%scene_path)
	while scene_result==Result.NONE:
		await wait_sec(0.1)

# シーンリザルトをセット	
func set_scene_result(id):
	# print("set_scene_result(%d)"%id)
	scene_result=id

# Called when the node enters the scene tree for the first time.
func _ready():
	n_hud=al_hud
	n_sound=al_sound
	main()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# HP加算
func add_hp(value):
	hp += value
	hp = clampi(hp,0,HP_MAX)
	n_hud.set_health(hp)
# Coin加算
func add_coin(value):
	coin += value
	n_hud.set_coin(coin)
# プレーヤにダメージ
func damage(value):
	n_sound.play_se(n_sound.SE_DAMAGE)
	add_hp(-value)
	if hp<=0:
		if n_player!=null:
			await n_player.dead_motion()
		await wait_sec(2)
		set_scene_result(Result.GAME_OVER)
# 秒待ち
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout
# プレーヤノードをセット
func set_player(node):
	n_player=node
# プレーヤ死亡か?
func is_player_dead():
	return hp<=0
