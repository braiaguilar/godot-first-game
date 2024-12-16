extends Area2D

@onready var timer: Timer = $Timer
const DEATH_DELAY_TIME = 0.5

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("die"):
        Engine.time_scale = DEATH_DELAY_TIME
        body.get_node("CollisionShape2D").queue_free()
        body.die()
        timer.start()

func _on_timer_timeout() -> void:
    Engine.time_scale = 1.0
    get_tree().reload_current_scene()
