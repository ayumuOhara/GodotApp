extends Node2D

var n_sec_timer
var n_tree_timer
var n_apple_text
var n_tree_button
var n_power_button
@export var n_time_record : Panel
@export var n_sound : Node
var apple_rect : Rect2

var apple_count : int # リンゴの数
var is_started : bool # スタートしたか?
var sec_count : int  # 秒カウント
var tree_count : int # リンゴの木の数
var click_power : int  # クリックパワー
var time_record_list : Array # タイムレコード用リスト
var time_record_idx : int  # タイムレコード用リストのインデックス

const TREE_APPLE_COST =100
const POWER_APPLE_COST = 10
const APPLE_PER_TREE = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	n_sec_timer=get_node("SecTimer")
	n_tree_timer=get_node("TreeTimer")
	n_apple_text=get_node("HUD/AppleText")
	n_tree_button=get_node("HUD/TreeButton")
	n_power_button=get_node("HUD/PowerButton")
	# Appleの領域取得
	var n_apple=get_node("Apple")
	apple_rect=n_apple.get_rect()
	apple_rect.position=n_apple.to_global(apple_rect.position)
	# 初期化
	apple_count = 0
	is_started=false
	sec_count = 0
	tree_count = 0
	click_power = 0
	time_record_list=[100,1000,10000]
	time_record_idx=0
	print_tree_button(0)
	print_power_button(0)
	stop_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# 入力イベントの処理
func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos=get_global_mouse_position()
		if apple_rect.has_point(mouse_pos):
			if is_started==false:
				is_started=true
				start_timer()
			add_apple(click_power+1)
			n_sound.play_se(n_sound.SeId.CLICK)

# TreeButtonが押された処理
func _on_tree_button_pressed():
	if apple_count >= TREE_APPLE_COST:
		add_apple(-TREE_APPLE_COST)
		tree_count += 1
		print_tree_button(tree_count)
		n_sound.play_se(n_sound.SeId.TREE_UP)
	else:
		n_sound.play_se(n_sound.SeId.BEEP)

# PowerButtonが押された処理			
func _on_power_button_pressed():
	if apple_count >= POWER_APPLE_COST:
		add_apple(-POWER_APPLE_COST)
		click_power += 1
		print_power_button(click_power)
		n_sound.play_se(n_sound.SeId.POWER_UP)
	else:
		n_sound.play_se(n_sound.SeId.BEEP)

# SecTimerのタイムアウト処理
func _on_sec_timer_timeout():
	sec_count +=1
	n_time_record.print_now_time(sec_count)

# TreeTimerのタイムアウト処理	
func _on_tree_timer_timeout():
	add_apple( tree_count * APPLE_PER_TREE)

func start_timer():
	n_sec_timer.start()
	n_tree_timer.start()

func stop_timer():
	n_sec_timer.stop()
	n_tree_timer.stop()
	
func add_apple(add):
	apple_count += add
	print_apple_text(apple_count)
	# time_recordチェック
	if time_record_idx < time_record_list.size():
		if apple_count >= time_record_list[time_record_idx]:
			match time_record_idx:
				0:
					n_time_record.print_1k_time(sec_count)
				1: 
					n_time_record.print_10k_time(sec_count)
				2: 
					n_time_record.print_100k_time(sec_count)
			time_record_idx +=1
			n_sound.play_se(n_sound.SeId.HI_SCORE)

# TreeButtonのテキスト更新	
func print_tree_button( tree ):
	var str ="リンゴの木 x %d\n(%d apples)" % [tree,TREE_APPLE_COST]
	n_tree_button.text=str

# PowerButtonのテキスト更新
func print_power_button( power):
	var str = "クリックパワー x %d\n(%d apples)" % [power,POWER_APPLE_COST]
	n_power_button.text = str

# AppleTextのテキスト更新
func print_apple_text( count ):
	var str="%d apples" % count
	n_apple_text.text=str
