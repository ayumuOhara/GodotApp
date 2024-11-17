extends Node2D
class_name Level

@export var n_player : Node2D
@export var n_spawner : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_player!=null)
	assert(n_spawner!=null)
	Game.set_player(n_player)
	n_player.position.x=Game.SCREEN_WIDTH/2

# 難易度タイマーのtimeout
func _on_difficult_timer_timeout():
	Game.add_difficulty()
	n_spawner.apply_difficulty()

# プレーヤのgame_overシグナル
func _on_player_game_over():
	Hud.show_game_over()
	await Game.wait_sec(3)
	Game.set_scene_result(Game.SCENE_NEXT)

# プレーヤのlevel_completeシグナル
func _on_player_level_complete():
	Hud.show_complete()
	await Game.wait_sec(3)
	Game.set_scene_result(Game.SCENE_NEXT)
