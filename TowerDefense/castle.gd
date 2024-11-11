extends Node2D
class_name Castle

signal castle_damage

@export var n_sprite : Sprite2D
@export var n_health : ProgressBar
var n_common

var castle_image: Array=[preload("res://assets/castle.png"), preload("res://assets/enemycastle.png") ]
var max_hp:int = 50
var hp : int
var is_player_side : bool

func _ready():
	assert(n_sprite!=null)
	assert(n_health!=null)
	n_common=al_common
	n_health.max_value=max_hp

# hp表示
func print_hp():
	n_health.value=hp
#　初期化
func init(is_player):
	is_player_side=is_player
	var idx = 0
	if is_player:
		idx=1	
	n_sprite.texture = castle_image[ idx ]
	hp=max_hp
	print_hp()

# ダメージ処理
func damage(dmg):
	hp = clampi(hp-dmg,0,max_hp)
	print_hp()
# 死亡?
func is_dead():
	return hp<=0

# Area2Dになにかか衝突した
func _on_area_2d_area_entered(area):
	if area.get_parent().is_player_side==is_player_side:
		return
	if area.name=="SoldierAttackArea":
		var soldier=area.get_parent()
		#emit_signal("castle_damage",self,soldier)
		castle_damage.emit(self,soldier)
