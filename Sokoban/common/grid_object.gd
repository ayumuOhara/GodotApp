extends Node2D
## グリッド(インデックス)座標系で動作するオブジェクトの基底
class_name GridObject

const Point2 = preload("res://common/point2.gd")

var point = Point2.new()
var dir :int = Direction.DIR_DOWN

## グリッド座標系を設定
func set_pos(x:int, y:int, is_center:bool)->void:
	# グリット座標系をワールド差表敬に変換して描画座標に反映する
	position.x = Field.idx_to_world_x(x, is_center)
	position.y = Field.idx_to_world_y(y, is_center)
	point.set_xy(x, y)

## グリッド座標系で移動
func move_pos(x:int, y:int, span:float):
	const COUNT=8
	var px = Field.idx_to_world_x(x,true)
	var py = Field.idx_to_world_y(y,true)
	var to_pos=Vector2(px,py)
	var from_pos=position
	var span_t=span/COUNT
	for t in range(COUNT):
		await Common.wait_sec(span_t)
		position = from_pos.lerp(to_pos,float(t+1)/COUNT)
	position = to_pos
	point.set_xy(x,y)
	
## 方向を設定する
func set_dir(dir:int)->void:
	self.dir = dir
## 指定の座標と一致しているか?
func is_same_pos(x:int, y:int)->bool:
	return point.equal_xy(x, y)

## グリット座標系のXを取得
func idx_x()->int:
	return point.x
## グリット座標系のYを取得
func idx_y()->int:
	return point.y
