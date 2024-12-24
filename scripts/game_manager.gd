extends Node

@onready var lb_score = $"../player/hud/lb_score"

var score = 0

func add_point_coin() -> void:
	score += 1
	lb_score.text = str(score)
