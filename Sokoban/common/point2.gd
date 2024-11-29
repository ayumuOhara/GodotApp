#extends Node

const INVALID = -1

var x:int = 0
var y:int = 0
## コンストラクター
func _init(x:int=0, y:int=0)->void:
	set_xy(x, y)
## xyを設定
func set_xy(x:int, y:int)->void:
	self.x=x
	self.y=y

## コピー
func copy(src)->void:
	set_xy(src.x, src.y)

## リセット
func reset()->void:
	# 無効な値にする
	set_xy(INVALID, INVALID)

## 同値か?
func equal(src)->bool:
	return equal_xy(src.x, src.y)
func equal_xy(x:int, y:int)->bool:
	return self.x == x and self.y == y
## 値が有効か?
func is_valid()->bool:
	return x != INVALID and y != INVALID
## 加算代入
func iadd(p):
	self.x += p.x
	self.y += p.y
## 減算代入
func isub(p):
	self.x -= p.x
	self.y -= p.y
## 近く(隣の上下左右)か?
func is_close(src)->bool:
	var dx = abs(self.x - src.x)
	var dy = abs(self.y - src.y)
	return dx + dy == 1
