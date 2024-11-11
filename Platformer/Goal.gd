extends Area2D

var is_goal : bool = false
var coin_scene = preload("res://coin.tscn")
@export var n_sprite : Sprite2D 
var n_game

# Called when the node enters the scene tree for the first time.
func _ready():
	n_game=al_game
	is_goal=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# なにかが重なった	
func _on_body_entered(body):
	if body.name=="Player" and is_goal==false:
		n_sprite.frame=1
		is_goal=true
		await shower_coin()
		await get_tree().create_timer(3).timeout
		n_game.set_scene_result(n_game.Result.GAME_CLEAR)

# コインシャワー演出
func shower_coin():
	for i in range(200):
		var coin = coin_scene.instantiate()
		coin.falldown=true
		var x=randf_range(-100,100)
		coin.position=global_position+Vector2(x,-500)
		get_tree().root.add_child(coin)
		await get_tree().create_timer(0.01).timeout
