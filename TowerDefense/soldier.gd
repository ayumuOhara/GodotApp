extends Node2D
class_name Soldier

### ノード ###
@export var n_anim : AnimatedSprite2D
@export var n_attack_collision : CollisionShape2D
@export var n_attack_start_collision : CollisionShape2D
@export var n_soldier_collision: CollisionShape2D
var n_common
var n_sound

### プロパティ ###
@export var is_player_side : bool
@export var speed : float = 75
@export var attack : float = 1
@export var defense : float = 0
@export var cost    : int  =50 # 生成するのに必要なスコア
@export var reload_time : float =1 # 生成したあとのインターバル時間
@export var attack_time : float =0.1 # SoldierAttackAreaが有効な時間
@export var attack_rate : float =0.7
@export var attack_frame : float =4
@export var attack_speed : float =1.0
#@export var idle_speed : float =1.0   # IDLE時の移動スピード
@export var max_hp : float = 10
@export var knockback_count : int =3  # 0～max_hp 中にノックバックする回数

### 変数 ###
var hp :int      # HP
var state : int  # ステータス
var cooldown_timer : float # クールダウンタイマー
var knockback_left : int # 0～knockback_count
var knockback_hp : float # 次のknockbackするHP値
var knockback_velocity : Vector2=Vector2(5,-6)

### 定数 ###
const DAMAGE_MIN : float =1.0

# ステータスenum
enum{
	ST_IDLE,     # 通常
	ST_ATTACK,   # 攻撃中
	ST_COOLDOWN, # クールダウン(攻撃後)中
	ST_DAMAGE,   # ダメージ中
}
# アニメ名、プロパティ名
const _IDLE="idle"
const _ATTACK="attack"
const _DAMAGE="damage"
const _DISABLED="disabled"

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_anim!=null)
	assert(n_attack_start_collision!=null)
	assert(n_attack_collision!=null)
	assert(n_soldier_collision!=null)
	n_common = al_common
	n_sound = al_sound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state==ST_IDLE:
		position.x+= speed * delta
		
	elif state==ST_ATTACK:
		if n_anim.frame>= attack_frame:
			cooldown_timer=attack_rate
			state=ST_COOLDOWN
			activate_attack_area()
			
	elif state==ST_COOLDOWN:
		cooldown_timer -= delta
		if cooldown_timer <= 0.0:
			n_attack_start_collision.disabled=false
			state=ST_IDLE
			n_anim.play(_IDLE)

# 攻撃当たり判定を有効化
func activate_attack_area():
	n_attack_collision.disabled = false
	await n_common.wait_sec(attack_time)
	n_attack_collision.disabled = true
# 初期化
func init(is_player:bool):
	is_player_side = is_player
	# 準備待ち
	await ready
	# 初期化
	n_attack_collision.disabled=true
	hp=max_hp
	state=ST_IDLE
	set_knockback_left(knockback_count)
	n_anim.sprite_frames.set_animation_loop(_ATTACK,false)
	n_anim.play(_IDLE)
	if is_player:
		# プレーヤ側は左向き
		speed = -abs(speed)
		knockback_velocity.x = abs(knockback_velocity.x)
		scale.x = -1
	else:
		# 敵は右向き
		speed = abs(speed)
		knockback_velocity.x = -abs(knockback_velocity.x)
		scale.x = 1
# 攻撃処理
func attack_start():
	n_attack_start_collision.set_deferred(_DISABLED,true)
	
	state=ST_ATTACK
	n_anim.play(_ATTACK, attack_speed)

# ダメージ処理
func damage(dmg):
	hp -= dmg
	# 
	if state!=ST_DAMAGE and hp <= knockback_hp:
		state=ST_DAMAGE
		# コリジョン無効化
		n_attack_collision.set_deferred(_DISABLED,true)
		n_attack_start_collision.set_deferred(_DISABLED,true)
		n_soldier_collision.set_deferred(_DISABLED,true)
		# knockback_leftのデリクメント
		while knockback_hp<hp:		
			set_knockback_left( knockback_left-1)
		# アニメ再生
		n_anim.play(_DAMAGE)
		# ノックバック移動
		var velocity=knockback_velocity
		for i in range(48):
			position += velocity
			velocity.y+=0.25
			await n_common.wait_sec(0)
		# 死亡または、IDLE再開
		if hp<=0.0:
			queue_free()
		else:
			state=ST_IDLE
			n_anim.play(_IDLE)
		# コリジョン有効化
		n_attack_start_collision.set_deferred(_DISABLED,false)
		n_soldier_collision.set_deferred(_DISABLED,false)
	
# 負け側なら、自滅
func remove_if_lose(is_player_win:bool):
	if is_player_win!=is_player_side:
		queue_free()

# ノックバック残数の設定
func set_knockback_left(left):
	knockback_left = left
	knockback_hp=float(max_hp) * (left-1) / knockback_count

# SoldierAttackStartに何かが衝突した
func _on_soldier_attack_start_area_entered(area):
	# 味方なら無視
	if area.get_parent().is_player_side == is_player_side:
		return
	if area.name=="SoldierArea" or area.name=="CastleArea":
		attack_start()
	
# SoliderAttackAreaに何かかが衝突した
func _on_soldier_attack_area_area_enterd(area):
	pass

# SoldierAreaに何かが称津とした
func _on_soldier_area_area_entered(area):
	# 味方なら無視
	if area.get_parent().is_player_side == is_player_side:
		return
	if area.name=="SoldierAttackArea":
		var atk=area.get_parent().attack
		var def=defense
		var dmg=n_common.calc_damage(atk,def)
		damage(dmg)
		n_sound.play_se(Sound.SE_HIT)


func _on_soldier_attack_area_area_entered(area):
	pass # Replace with function body.


func _on_soldier_attack_area_start_area_entered(area):
	pass # Replace with function body.
