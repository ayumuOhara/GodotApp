extends Node

const Point2 = preload("res://common/point2.gd")

enum {
	DIR_NONE,
	DIR_LEFT,
	DIR_UP,
	DIR_RIGHT,
	DIR_DOWN,
}
## 向きのVector2を取得
func get_vector(dir:int)->Vector2:
	match dir:
		DIR_LEFT:
			return Vector2(-1, 0)
		DIR_UP:
			return Vector2(0, -1)
		DIR_RIGHT:
			return Vector2(1, 0)
		_:
			return Vector2(0, 1)
## 向きのPoint2を取得
func get_point2(dir:int )->Point2:
	match dir:
		DIR_LEFT:
			return Point2.new(-1, 0)
		DIR_UP:
			return Point2.new(0, -1)
		DIR_RIGHT:
			return Point2.new(1, 0)
		_:
			return Point2.new(0, 1)
## 向きの名前を取得
func to_name(dir:int)->String:
	match dir:
		DIR_LEFT:
			return "LEFT"
		DIR_UP:
			return "UP"
		DIR_RIGHT:
			return "RIGHT"
		DIR_DOWN:
			return "DOWN"
		_:
			return "NONE"
