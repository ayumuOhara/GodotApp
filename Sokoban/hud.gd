extends CanvasLayer

signal reset
signal undo
signal redo

@export var n_caption : Label
@export var n_step : Label
@export var n_reset : Button
@export var n_undo : Button
@export var n_redo : Button

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(n_caption!=null)
	assert(n_step!=null)
	assert(n_reset!=null)
	assert(n_undo!=null)
	assert(n_redo!=null)
	hide_caption()
	n_undo.hide()
	n_redo.hide()

## キャプション表示	
func show_caption(text:String):
	n_caption.text=text
	n_caption.show()
## キャプション消去
## hide()するとレイアウトが崩れるので空白を表示
func hide_caption():
	n_caption.text=" "
	n_caption.show()

func print_step(step:int):
	n_step.text = "STEP : %d" % step

func set_step_visible(f:bool):
	n_step.visible = f
func set_reset_visible(f:bool):
	n_reset.visible = f
func set_undo_visible(f:bool):
	n_undo.visible = f
func set_redo_visible(f:bool):
	n_redo.visible = f

## resetボタンが押されたとき
func _on_reset_pressed():
	reset.emit()
## undoボタンが押されたとき
func _on_undo_pressed():
	undo.emit()
## redoボタンが押されたとき
func _on_redo_pressed():
	redo.emit()
