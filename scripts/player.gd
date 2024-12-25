extends CharacterBody2D

# Node imports
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sfx: AudioStreamPlayer2D = $jump_sfx
@onready var hurt_sfx: AudioStreamPlayer2D = $hurt_sfx

# Constants
const GRAVITY_INTENSITY = 1.2
const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const SPRINT_MULTIPLIER = 1.6

# Variables
var current_speed = SPEED
var player_is_dead = false

func _physics_process(delta: float) -> void:
    apply_gravity(delta)
    move_and_slide()

    if player_is_dead == true:
        velocity.x = move_toward(velocity.x, 0, 2)
        return

    handle_movement()
    handle_idle()
    handle_jump()
    handle_sprint()

func apply_gravity(delta: float) -> void:
    if not is_on_floor():
        animated_sprite.play("jump")
        velocity += (get_gravity() * GRAVITY_INTENSITY) * delta

func handle_movement() -> void:
    var direction = Input.get_axis("move_left", "move_right")
    if direction != 0:
        animated_sprite.flip_h = direction < 0
        animated_sprite.play("sprint")
        velocity.x = direction * current_speed
    else:
        velocity.x = move_toward(velocity.x, 0, current_speed)

func handle_idle() -> void:
    if abs(velocity.x) == 0 and is_on_floor():
        animated_sprite.play("idle")

func handle_jump() -> void:
    if Input.is_action_just_pressed("jump") and is_on_floor():
        jump_sfx.play()
        velocity.y = JUMP_VELOCITY

func handle_sprint() -> void:
    if Input.is_action_just_pressed("sprint") and is_on_floor():
        current_speed = SPEED * SPRINT_MULTIPLIER
    if Input.is_action_just_released("sprint"):
        current_speed = SPEED

func die() -> void:
    player_is_dead = true
    animated_sprite.play("death")
    hurt_sfx.play()