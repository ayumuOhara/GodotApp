extends Node

const SCREEN_WIDTH = 800
const SCREEN_HEIGHT= 480

const DOKAN_WIDTH = 194
const DOKAN_HEIGHT = 611
const DOKAN_SPEED_BASE=150
const DOKAN_INTERVAL_BASE=5.0

var dokan_count:int  # ドカンの生成数
var level:int        # レベル
var dokan_between_space:int # ドカンの間の空間
var dokan_speed: float
var dokan_create_interval : float

# ドカン生成数→レベル
const count_level:Array[int] =[
	5,  # Level 0
	10, # Level 1
	15, # Level 2
	20, # Level 3
	25, # Level 4
	30, # Level 5
]
# レベル→ドカンのすき間
const level_between_space:Array[int]=[
	200, # Level 0
	180, # Level 1
	180, # Level 2
	160, # Level 3
	160, # Level 4
	160, # Level 5
]
# レベル→ドカンのスピード
const level_speed:Array[float]=[
	DOKAN_SPEED_BASE *1.0,	# Level 0
	DOKAN_SPEED_BASE *1.0,	# Level 1
	DOKAN_SPEED_BASE *1.1,	# Level 2
	DOKAN_SPEED_BASE *1.1,	# Level 3
	DOKAN_SPEED_BASE *1.2,	# Level 4
	DOKAN_SPEED_BASE *1.2,	# Level 5
	DOKAN_SPEED_BASE *1.3,	# Level 6
]
# レベル→ドカンの生成インターバル
const level_interval:Array[float]=[
	DOKAN_INTERVAL_BASE*1.0, # Level 0
	DOKAN_INTERVAL_BASE*1.0, # Level 1
	DOKAN_INTERVAL_BASE*0.95, # Level 2
	DOKAN_INTERVAL_BASE*0.95, # Level 3
	DOKAN_INTERVAL_BASE*0.9, # Level 4
	DOKAN_INTERVAL_BASE*0.8, # Level 5
]
# 初期化
func init():
	dokan_count=0
	level=0
	update_param(level)	

# ドカンのカウント加算
func add_dokan_count():
	dokan_count +=1
	update_level(dokan_count)
# レベル更新
func update_level(count):
	if level < count_level.size():
		if count >= count_level[level]:
			level += 1
			update_param(level)	
# パラメータ更新
func update_param(lv):
	if 	lv < level_between_space.size():
		dokan_between_space = level_between_space[lv]
	if lv < level_speed.size():
		dokan_speed = level_speed[lv]
	if lv < level_interval.size():
		dokan_create_interval=level_interval[lv]	

# 秒待ち
func wait_sec(sec):
	await get_tree().create_timer(sec).timeout
# ボーズon/off
func pause(flag:bool):
	get_tree().paused=flag
