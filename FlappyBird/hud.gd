extends CanvasLayer

@export var n_msg : Label
@export var n_score: Label

func _ready():
	assert(n_msg!=null)
	assert(n_score!=null)

# スコア表紙
func print_score(score):
	n_score.text="Score : %d" % score

# "READY"表示して　next アクション待ち
func wait_ready():
	n_msg.text="READY"
	n_msg.show()
	await Game.wait_sec(1)
	await wait_action("next")
	n_msg.hide()
	await wait_blink(5)

# "GAME OVER" 表示して nextアクション待ち
func wait_game_over():
	n_msg.text="GAME OVER"
	n_msg.show()
	await Game.wait_sec(1)
	await wait_action("next")
	n_msg.hide()

# "PASUE" 表示して pause アクション待ち
func wait_pause():
	n_msg.text="PAUSE"
	n_msg.show()
	await Game.wait_sec(1)
	await wait_action("pause")
	await wait_blink(5)
	n_msg.hide()

# next ボタンが押されるのを待つ
func wait_action(name):
	while true:
		await Game.wait_sec(0.1)
		if Input.is_action_pressed( name ):
			break;

# msgをプリンク
func wait_blink(count):
	for i in range(0,count):
		if i % 2 ==0:
			n_msg.hide()
		else:
			n_msg.show()
		await Game.wait_sec(0.5)
