extends Node

const ENEMY_GROUP="enemy"

var enemy_scene =preload("res://enemy.tscn")
var player_bullet_scene =preload("res://bullet.tscn")
var enemy_bullet_scene =preload("res://enemy_bullet.tscn")

var screen_size: Vector2

## 敵の弾を生成
func create_enemy_bullet(pos):
	var bullet=enemy_bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(pos)
## ブレーヤの弾を生成
func create_player_bullet(pos):
	var bullet=player_bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(pos)
## エネミーを生成
func create_enemy(pos):
	var enemy=enemy_scene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.start(pos)
	return enemy

## ツリーエントリー時
func _enter_tree():
	screen_size = get_tree().root.get_viewport().get_visible_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

## 秒待ち
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout
