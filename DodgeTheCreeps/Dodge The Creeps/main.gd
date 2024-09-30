extends Node

#aaaaaa

var score : int
var hiScore : int
var mob_scene = preload("res://mob.tscn")
var n_score_timer
var n_mob_timer
var n_start_position
var n_mob_spawn_location
var n_player
var n_hud
var n_sound
var is_game_over

func main():
	n_player.hide()
	show_title()
	while true:
		await play()

func play():
	score=0
	hiScore=10
	n_hud.update_score(score)
	await n_hud.wait_start()  # スタートボタンが押されるのを待つ
	n_sound.play_bgm()
	n_player.start(n_start_position.position)
	n_hud.show_message("Ready")
	await wait_sec(1)
	n_hud.hide_message()
	start_timer()
	is_game_over=false
	while is_game_over==false:
		#print(n_mob_spawn_location.position)
		await wait_sec(0.1)

	n_sound.stop_bgm()
	n_sound.play_game_over()
	n_hud.show_message("Game Over")
	await wait_sec(2)
	delete_all_mobs()
	show_title()
	await wait_sec(1)

# 時間(秒)待ち	
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout

# タイトル表示
func show_title():
	n_hud.show_message("Dodge the Creeps")

# mobを全部消去
func delete_all_mobs():
	get_tree().call_group("mobs","queue_free")

# Called when the node enters the scene tree for the first time.
func _ready():
	# ノードを取得
	n_score_timer=get_node("ScoreTimer")
	n_mob_timer =get_node("MobTimer")
	n_start_position=get_node("StartPosition")
	n_mob_spawn_location=get_node("MobPath/MobSpawnLocation")
	n_player = get_node("Player")
	n_hud = get_node("HUD")
	n_sound = get_node("Sound")
	main()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_timer():
	n_mob_timer.start()
	n_score_timer.start()

func stop_timer():
	n_mob_timer.stop()
	n_score_timer.stop()

# MobTimer から一定時間ごとに呼ばれる
func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate();
	n_mob_spawn_location.progress_ratio = randf()
	mob.position = n_mob_spawn_location.position
	var dir = n_mob_spawn_location.rotation + PI/2
	dir += randf_range(-PI/4, PI/4)
	mob.rotation = dir
	var speed=randf_range(150,250)
	var velocity =	Vector2(speed,0)
	mob.linear_velocity = velocity.rotated(dir)
	add_child(mob)

# ScoreTimer から一定時間ごとに呼ばれる
func _on_score_timer_timeout():
	score +=1
	n_sound.play_score()
	if score > hiScore:
		hiScore=score
		n_hud.update_hi_score(hiScore)
	n_hud.update_score(score)

func _on_player_hit():
	stop_timer()
	is_game_over=true
