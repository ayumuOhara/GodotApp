extends GridObject
## プレーヤ
class_name Player

@export var n_anim : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_anim!=null)
	set_dir_anim(Direction.DIR_DOWN)

func update(delta:float)->void:
	if Common.can_operate==false:
		return
	
	if Input.is_action_just_pressed("ui_left"):
		set_dir_anim(Direction.DIR_LEFT)
		move()
	elif Input.is_action_just_pressed("ui_up"):
		set_dir_anim(Direction.DIR_UP)
		move()
	elif Input.is_action_just_pressed("ui_right"):
		set_dir_anim(Direction.DIR_RIGHT)
		move()
	elif Input.is_action_just_pressed("ui_down"):
		set_dir_anim(Direction.DIR_DOWN)
		move()
	
func move():
	# 移動先を調べる
	var prev_dir = self.dir
	var now = Point2.new(self.point.x, self.point.y)
	var next = Point2.new(now.x, now.y)
	var d = Direction.get_point2(self.dir)
	next.iadd(d)
	
	const MOVE_SPAN=0.1 # 秒
	if Field.is_crate(next.x, next.y):
		# 移動先が荷物
		if Field.can_move_crate(next.x, next.y, d.x, d.y):
			# 移動できる
			Field.move_crate_take_time(next.x, next.y, d.x, d.y, MOVE_SPAN)
			# プレーヤ移動
			move_pos(next.x, next.y,MOVE_SPAN)
			# リプレイデータ追加
			add_replay(now, prev_dir, next, self.dir)
			await wait_move(MOVE_SPAN)
	elif Field.can_move(next.x, next.y):
		move_pos(next.x, next.y, MOVE_SPAN)
		# リプレイデータ追加
		add_replay(now, prev_dir, next, Direction.DIR_NONE)
		await wait_move(MOVE_SPAN)

func wait_move(span:float):
	Common.can_operate = false
	await Common.wait_sec(span+0.1)
	Common.can_operate = true

## リプレイ追加
func add_replay(player_pos:Point2, player_dir:int, crate_pos:Point2, crate_dir:int ):
	var replay=Common.ReplayData.new(player_pos, player_dir, crate_pos, crate_dir)
	Common.add_undo(replay)

## dir設定し、アニメ
func set_dir_anim(dir:int)->void:
	self.dir=dir
	match dir:
		Direction.DIR_LEFT:
			n_anim.play("left")
		Direction.DIR_UP:
			n_anim.play("up")
		Direction.DIR_RIGHT:
			n_anim.play("right")
		_:
			n_anim.play("down")
