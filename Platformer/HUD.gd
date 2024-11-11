extends CanvasLayer

@export var n_health : ProgressBar
@export var n_coin : Label

# healthの値セット
func set_health(value):
	n_health.value=value
# healthのmax値セット
func set_health_max(value):
	n_health.max_value=value
# Coin数セット
func set_coin(value):
	n_coin.text="%02d" % value
