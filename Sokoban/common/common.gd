extends Node

const Point2 = preload("res://common/point2.gd")

const FIRST_LEVEL=1
const FINAL_LEVEL=12

## -----------------------------------
## リプレイデータ
class ReplayData:
	var player_pos = Point2.new()
	var player_dir = Direction.DIR_NONE
	var crate_pos = Point2.new()
	var crate_dir = Direction.DIR_NONE
	## コンストラクター
	func _init(ppos:Point2, pdir:int, cpos:Point2, cdir:int)->void:
		player_pos = ppos
		player_dir = pdir
		crate_pos = cpos
		crate_dir = cdir
## -----------------------------------
## リプレイ管理
class ReplayMgr:
	var undo_list = [] 
	var redo_list = []
	# リセット
	func reset():
		undo_list.clear()
		redo_list.clear()
	# undoを追加
	func add_undo(d:ReplayData, is_clear_redo:bool=true):
		undo_list.append(d)
		if is_clear_redo:
			redo_list.clear()
	# undoできる数を取得
	func count_undo()->int:
		return undo_list.size()
	# undoを実行
	func undo(player:Player):
		# undoリスト空なら、なにもしない
		if undo_list.is_empty():
			return
		# 末尾から取り出す
		var d:ReplayData = undo_list.pop_back()
		player.set_pos(d.player_pos.x, d.player_pos.y, true)
		player.set_dir(d.player_dir)
		if d.crate_dir != Direction.DIR_NONE:
			# 荷物の位置も戻す
			var xprev = d.crate_pos.x
			var yprev = d.crate_pos.y
			var v = Direction.get_point2(d.crate_dir)
			var xnow = xprev + v.x
			var ynow = yprev + v.y
			var crate = Field.search_crate(xnow,ynow)
			crate.set_pos(xprev,yprev,true)
		# redoに追加
		add_redo(d)
		
	# redoを追加する
	func add_redo(d:ReplayData)->void:
		redo_list.append(d)	
	# redoできる数を取得
	func count_redo()->int:
		return redo_list.size()
	# redo を実行
	func redo(player:Player)->void:
		# redoリストが空ならなにもしない
		if redo_list.is_empty():
			return
		# 末尾から撮り出す
		var d:ReplayData = redo_list.pop_back()
		var p_vdir=Direction.get_point2(d.player_dir)
		var px = d.player_pos.x + p_vdir.x
		var py = d.player_pos.y + p_vdir.y
		player.set_pos(px, py, true)
		player.set_dir(d.player_dir)
		if d.crate_dir != Direction.DIR_NONE:
			# 荷物の位置も戻す
			var xprev = d.crate_pos.x
			var yprev = d.crate_pos.y
			var v = Direction.get_point2(d.crate_dir)
			var xnext = xprev + v.x
			var ynext = yprev + v.y	
			var crate = Field.search_crate(xprev,yprev)
			crate.set_pos(xnext, ynext, true)
		# undoに追加
		add_undo(d, false)
# -----------------------------------
#  common
var player:Player = null
var layers = []
var replay_mgr = ReplayMgr.new()
var level = FIRST_LEVEL
var can_operate = true

## レベルを最初に戻す
func reset_level() -> void:
	self.level=FIRST_LEVEL
## レベルを次にすすめる
func next_level()->void:
	self.level += 1
## 最終レベルを超えたか?
func completed_all_level()->bool:
	return self.level > FINAL_LEVEL	
## 最終レベルか?
func is_final_level()->bool:
	return self.level == FINAL_LEVEL
## 現在のレベルを取得
func get_level() -> int:
	return self.level
## レベルシーンのパスを取得
func get_level_scene_path(level:int=0)->String:
	if level<=0:
		level=self.level
	return "res://level/level_%02d.tscn" % level
## セットアップ
func setup(player, layers):
	self.player=player
	self.layers=layers
	replay_mgr.reset()

## CanvasLayerを取得する
func get_layer(name:String)->CanvasLayer:
	return layers[name]
## UNDO 関連
func add_undo(data:ReplayData)->void:
	replay_mgr.add_undo(data)
func count_undo()->int:
	return replay_mgr.count_undo()
func get_undo_list():
	return replay_mgr.undo_list
## undoを実行する
func undo()->void:
	replay_mgr.undo(self.player)
## REDO関連
func count_redo()->int:
	return replay_mgr.count_redo()
func redo()->void:
	replay_mgr.redo(self.player)

## 秒待ち
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout
