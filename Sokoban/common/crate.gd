extends GridObject
## 荷物オブジェクト
class_name Crate

enum {
	TYPE_BROWN = Field.T_CRATE1,
	TYPE_RED = Field.T_CRATE2,
	TYPE_BLUE = Field.T_CRATE3,
	TYPE_GREEN = Field.T_CRATE4,
}

@export var n_spr : Sprite2D
@export var n_spr2 : Sprite2D

var type =TYPE_BROWN
var timer =0.0 

## 荷物の種類を取得
func get_type()->int:
	return self.type
## セットアップ
func setup(x:int, y:int, type:int)->void:
	self.type=type
	n_spr.frame= get_anim_frame()
	set_pos(x, y, true)
## 更新
func update(delta:float)->void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_spr!=null)
	assert(n_spr2!=null)
	n_spr2.visible = false
	
## アニメーションの更新
func _process(delta):
	self.timer += delta
	var x=idx_x()
	var y=idx_y()
	if Field.is_match_crate_type(x, y, self.type):
		# マッチしてるので点滅する
		n_spr2.visible=true
		n_spr2.modulate.a = 0.5 * abs(sin(timer*4))
	else:
		n_spr2.visible=false	

## アニメフレーム値を取得
func get_anim_frame()->int:
	match(self.type):
		TYPE_BROWN:
			return 0
		TYPE_RED:
			return 1
		TYPE_BLUE:
			return 2
		_:
			return 3
