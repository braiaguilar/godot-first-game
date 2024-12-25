extends Area2D

@onready var timer: Timer = $Timer

const DEATH_DELAY_TIME = 0.5

func _on_body_entered(body: Node2D) -> void:
    Engine.time_scale = DEATH_DELAY_TIME
    body.die()
    timer.start()

func _on_timer_timeout() -> void:
    Engine.time_scale = 1.0
    get_tree().reload_current_scene()
