extends Node

@export var n_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_timer!=null)
	apply_difficulty()

# 難易度を反映する
func apply_difficulty():
	var difficulty = Game.level_difficulty
	var wait_time = 3.0 - 0.25 * difficulty
	if wait_time >= 0.25:
		n_timer.wait_time = wait_time

# タイマーのtimeout
func _on_timer_timeout():
	if Game.is_play_out:
		return
	var sel
	if Game.level_difficulty<=3:
		sel = randi_range(1,2)
	elif Game.level_difficulty<=5:  # ★ここを修正
		sel = randi_range(1,3)  # ★ここを修正
	else:                           # ★ここを追加
		sel = randi_range(2,4)  # ★ここを追加
	
	var x = randi_range(16,Game.SCREEN_WIDTH-16)
	var y = Game.get_player_position().y - Game.SCREEN_HEIGHT
	var pos=Vector2(x,y)
	var id
	match sel:
		1:
			id=Game.ENEMY_01
		2:
			id=Game.ENEMY_02
		3:
			id=Game.ENEMY_03
		4:                              # ★ここを追加
			id=Game.ENEMY_04            # ★ここを追加
			x=randi_range(16,Game.SCREEN_WIDTH/2)  # ★ここを追加 (要調整)
			y = Game.get_player_position().y - Game.SCREEN_HEIGHT*1.8 # ★ここを追加 (要調整)
			pos=Vector2(x,y)        # ★ここを追加
		_:
			print("illegal sel")
	Game.create_enemy(id,pos,self)
