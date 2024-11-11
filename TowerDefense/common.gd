extends Node
class_name Common

const DAMAGE_MIN=1.0

# 秒待ち
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout

# 攻撃力、防御力からダメージ値を計算
func calc_damage(atk,def):
	var min = ceil(atk*0.8)
	var max = ceil(atk*1.2)
	var dmg = randi_range(min,max) - def
	if dmg < DAMAGE_MIN:
		dmg = DAMAGE_MIN
	return dmg
