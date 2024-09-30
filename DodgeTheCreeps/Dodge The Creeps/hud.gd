extends CanvasLayer

var n_score_label
var n_message
var n_start_button
var is_start_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	n_score_label=get_node("ScoreLabel")
	n_message=get_node("Message")
	n_start_button=get_node("StartButton")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# メッセージ表示
func show_message(text):
	n_message.text=text
	n_message.show()

# メッセージ消去
func hide_message():
	n_message.hide()

# スタート待ち
func wait_start():
	n_start_button.show()
	is_start_pressed=false
	while is_start_pressed==false:
		await get_tree().create_timer(0.5).timeout
	n_start_button.hide()

# スコア更新
func update_score(score):
	n_score_label.text=str(score)

func _on_start_button_pressed():
	is_start_pressed=true
