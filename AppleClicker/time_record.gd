extends Panel

@export var n_now_time : Label
@export var n_1k_time : Label
@export var n_10k_time : Label
@export var n_100k_time : Label

func print_now_time(sec):
	n_now_time.text = get_time_text(sec)

func print_1k_time(sec):
	n_1k_time.text = get_time_text(sec)

func print_10k_time(sec):
	n_10k_time.text = get_time_text(sec)

func print_100k_time(sec):
	n_100k_time.text = get_time_text(sec)

func get_time_text(sec):
	var minute=sec/60
	sec %= 60
	if minute > 99:
		minute=99
		sec=59
	var str="%02d:%02d" % [minute,sec]
	return str
