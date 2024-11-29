extends Node2D

const Point2 = preload("res://common/point2.gd")
const player_scene = preload("res://player.tscn")
const crate_scene = preload("res://crate.tscn")

@export var tile_layer : CanvasLayer
@export var obj_layer : CanvasLayer
@export var crate_layer : CanvasLayer
@export var hud : CanvasLayer

const _DEBUG_UNDO_LOG = false

## ステータス
enum{
	ST_MAIN,
	ST_STAGE_CLEAR,
}

var player : Player = null
var state  = ST_MAIN

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(tile_layer!=null)
	assert(obj_layer!=null)
	assert(crate_layer!=null)
	
	# レベルを読み込む
	var level_path = Common.get_level_scene_path()
	var level_res = load(level_path)
	var level_obj = level_res.instantiate()
	tile_layer.add_child(level_obj)
	# Frontのタイルマップを取得する
	var tile_front:TileMap = level_obj.get_node("./Front")
	Field.setup(tile_front)
	for y in range(Field.TILE_HEIGHT):
		for x in range(Field.TILE_WIDTH):
			var pos=Vector2i(x,y)
			var v = tile_front.get_cell_source_id(0, pos)
			if create_obj(x, y, v):
				tile_front.set_cell(0, pos, Field.T_NONE)
	# もし上記で player生成されなかったら
	if self.player == null:
		push_warning("プレーヤの開始位置が設定されていません.")		
		var p=Field.searcg_random_none()
		create_player(p.x, p.y)
	# 共通モジュールにセットアップする
	var layers={
		"crate": crate_layer
	}
	Common.setup(self.player, layers)
	
## タイル情報からオブシェクトを生成
func create_obj(x:int, y:int, id:int)->bool:
	match id:
		Field.T_START:
			create_player(x,y)
			return true
		Field.T_CRATE1,Field.T_CRATE2,Field.T_CRATE3,Field.T_CRATE4:
			create_crate(x,y,id)
			return true
	# 生成されていない
	return false
## プレーヤの生成
func create_player(x:int, y:int)->void:
	self.player=player_scene.instantiate()
	self.player.set_pos(x,y,true)
	obj_layer.add_child(self.player)
## 荷物の生成
func create_crate(x:int, y:int, id:int)->void:
	var crate = crate_scene.instantiate()
	crate_layer.add_child(crate)
	crate.setup(x,y,id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		ST_MAIN:
			update_main(delta)
		ST_STAGE_CLEAR:
			update_stage_clear(delta)
##プレイ時の更新
func update_main(delta):
	#imer += delta
	# リセットアクション?
	if Input.is_action_pressed("ui_reset"):
		change_scene_self()
		return
	# プレーヤの更新
	player.update(delta)
	# 荷物の更新
	for crate in crate_layer.get_children():
		crate.update(delta)
	# UIの更新
	update_ui(delta)
	# ステージクリア?
	if Field.is_stage_clear():
		state=ST_STAGE_CLEAR
		var text="COMPELETED"
		if Common.is_final_level():
			text="ALL LEVELS COMPLETED"
		hud.show_caption(text)
		hud.set_redo_visible(false)
		hud.set_undo_visible(false)
		hud.set_reset_visible(false)
		
## ステージクリア時の更新
func update_stage_clear(delta):
	if Input.is_action_pressed("ui_accept"):
		Common.next_level()
		if Common.completed_all_level():
			# 全ステージクリアしたら最初から
			Common.reset_level()
		change_scene_self()
## UIの更新
func update_ui(delta):
	var cnt_undo = Common.count_undo()
	hud.print_step(cnt_undo)
	if cnt_undo > 0:
		hud.set_undo_visible(true)
	else:
		hud.set_undo_visible(false)
	# UNDOログの表示
	if _DEBUG_UNDO_LOG:
		for data in Common.get_undo_list():
			var d:Common.ReplayData = data
			var buf = "\n"
			var dir1 = Direction.to_name(d.player_dir)
			var dir2 = Direction.to_name(d.crate_dir)
			buf += "(%d %d)%s (%d %d)%s" % [d.player_pos.x, d.player_pos.y, dir1, d.crate_pos.x, d.crate_pos.y, dir2]
			print(buf)
	# redo 可能か?
	if Common.count_redo() > 0:
		hud.set_redo_visible(true)
	else:
		hud.set_redo_visible(false)
	
# このシーンを新たに始める
func change_scene_self():
	get_tree().change_scene_to_file("res://main.tscn")

## resetボタンが押された処理
func _on_hud_reset():
	if state == ST_MAIN and Common.can_operate:
		change_scene_self()
## undoボタンが押された処理
func _on_hud_undo():
	if state == ST_MAIN and Common.can_operate:
		Common.undo()
## redoボタンが押された処理
func _on_hud_redo():
	if state == ST_MAIN and Common.can_operate:
		Common.redo()
