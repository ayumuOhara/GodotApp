extends Node

const Point2 = preload("res://common/point2.gd")

const TILE_SIZE=64.0
const FIELD_OFS_X=0
const FIELD_OFS_Y=0
const TILE_WIDTH=12
const TILE_HEIGHT=8

enum{
	T_NONE = -1,
	# 通路
	T_BLANK = 0,
	# 壁
	T_BLOCK,
	# 荷物
	T_CRATE1,
	T_CRATE2,
	T_CRATE3,
	T_CRATE4,
	# 荷物を移動させる場所
	T_POINT1,
	T_POINT2,
	T_POINT3,
	T_POINT4,
	# プレーヤ(開始点)
	T_START,	
}
var _tile:TileMap = null
# セットアップ
func setup(tile:TileMap):
	_tile=tile

func get_cell(x:int,y:int):
	return _tile.get_cell_source_id(0, Vector2i(x, y))

func can_move(x:int, y:int):
	match get_cell(x, y):
		T_BLOCK:
			return false
		_:
			if is_crate(x, y):
				return false
			return true

func is_crate(x:int, y:int):
	if search_crate(x, y) !=null:
		return true
	return false

func search_crate(x:int, y:int):
	for crate in Common.get_layer("crate").get_children():
		if crate.is_same_pos(x, y):
			return crate
	return null

# 荷物を動かるか?
func can_move_crate(x:int, y:int, dx:int, dy:int):
	# 移動先をチェック
	if can_move(x+dx, y+dy) == false:
		return false
	# 指定位置は荷物?
	if is_crate(x, y) == false:
		return false
	
	return true
## 荷物を動かす
func move_crate(x:int, y:int, dx:int, dy:int):
	var crate = search_crate(x, y)
	var xnext = x + dx
	var ynext = y + dy
	crate.set_pos(xnext, ynext, true)
## 時間をかけて荷物を動かす
func move_crate_take_time(x:int, y:int, dx:int, dy:int, span:float):
	var crate = search_crate(x, y)
	var xnext = x + dx
	var ynext = y + dy
	crate.move_pos(xnext, ynext, span)

# 指定の荷物は、正しい位置にあるか
func is_match_crate_type(x:int, y:int, type:int):
	var v=get_cell(x,y)
	match v:
		T_POINT1:
			return type == T_CRATE1
		T_POINT2:
			return type == T_CRATE2
		T_POINT3:
			return type == T_CRATE3
		T_POINT4:
			return type == T_CRATE4
		_:
			return false
# ステージクリアか?
func is_stage_clear():
	for crate in Common.get_layer("crate").get_children():
		var x = crate.idx_x()
		var y = crate.idx_y()
		var type = crate.get_type()
		if is_match_crate_type(x,y,type) == false:
			return false
	# すべて一致した
	return true
# インデックスX座標をワールドX座標に変換する
func idx_to_world_x(x:int, is_center:bool=false):
	var xx = x
	if is_center:
		xx += 0.5
	return FIELD_OFS_X + (xx * TILE_SIZE)
# インデックスX座標をワールドX座標に変換する
func idx_to_world_y(y:int, is_center:bool=false):
	var yy = y
	if is_center:
		yy += 0.5
	return FIELD_OFS_Y + (yy * TILE_SIZE)
# 何もない場所をランダムで返す
func search_random_none():
	var arr=[]
	for y in range(TILE_HEIGHT):
		for x in range(TILE_WIDTH):
			if _tile.get_cell(x, y) == T_NONE:
				arr.append(Point2.new(x, y))
	arr.shuffle()
	return arr[0]
