extends Node

@export var n_se_list: Array[AudioStreamPlayer]
@export var n_bgm_list: Array[AudioStreamPlayer]

enum{
	BGM_LEVEL= 0,
	BGM_TITLE = 1,
	BGM_NONE = -1,
}
enum{
	SE_EXPLOSION,  # 爆発SE
	SE_SHOT,       # 弾発射SE
}
var bgm_now = BGM_NONE
# BGM再生
func play_bgm(id):
	if bgm_now==id:
		return
	stop_bgm()
	if 0<=id and id<n_bgm_list.size():
		n_bgm_list[id].play()
		bgm_now=id
# BGM停止
func stop_bgm():
	var id=bgm_now
	if 0<=id and id<n_bgm_list.size():
		n_bgm_list[id].stop()
		bgm_now=BGM_NONE
# SE再生
func play_se(id):
	if 0<=id and id<n_se_list.size():
		n_se_list[id].play()
