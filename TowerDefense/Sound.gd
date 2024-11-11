extends Node
class_name Sound

@export var n_bgm : AudioStreamPlayer
@export var n_se_list: Array[AudioStreamPlayer]
# SEのid
enum{
	SE_HIT,
}

func _ready():
	assert(n_bgm!=null)

# BGM再生
func play_bgm():
	n_bgm.play()
# BGM停止
func stop_bgm():
	n_bgm.stop()
# SE再生
func play_se(id):
	if 0 <= id and id < n_se_list.size():
		n_se_list[id].play()
