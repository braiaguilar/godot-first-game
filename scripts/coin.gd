extends Area2D

@onready var game_manager = %game_manager
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point_coin()
	animation_player.play("pickup")
