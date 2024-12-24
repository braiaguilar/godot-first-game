extends CharacterBody2D

# Constants
const GRAVITY_INTENSITY = 1.2
const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const SPRINT_MULTIPLIER = 1.6
const STATE_IDLE = "idle"
const STATE_SPRINT = "sprint"
const STATE_ROLL = "roll"
const STATE_JUMP = "jump"
const STATE_DEATH = "death"

# Variables
var jump_counter = 0
var current_speed = SPEED
var player_state = STATE_IDLE

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
    animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
    if player_state == STATE_DEATH:
        return

    apply_gravity(delta)
    handle_jump()
    handle_sprint()
    handle_movement()
    update_animation()
    move_and_slide()

func apply_gravity(delta: float) -> void:
    if not is_on_floor():
        velocity += (get_gravity() * GRAVITY_INTENSITY) * delta

func handle_jump() -> void:
    if Input.is_action_just_pressed(STATE_JUMP) and jump_counter < 2:
        velocity.y = JUMP_VELOCITY
        jump_counter += 1

    if is_on_floor() and jump_counter >= 2:
        jump_counter = 0

func handle_sprint() -> void:
    if Input.is_action_just_pressed(STATE_SPRINT) and is_on_floor():
        current_speed = SPEED * SPRINT_MULTIPLIER
    if Input.is_action_just_released(STATE_SPRINT):
        current_speed = SPEED

func handle_movement() -> void:
    var direction = Input.get_axis("move_left", "move_right")
    if direction != 0:
        animated_sprite.flip_h = direction < 0
        velocity.x = direction * current_speed
    else:
        velocity.x = move_toward(velocity.x, 0, current_speed)

func update_animation() -> void:
    if player_state in [STATE_ROLL, STATE_DEATH]:
        return
    
    if not is_on_floor():
        player_state = STATE_JUMP
        animated_sprite.play(STATE_JUMP)
    elif Input.is_action_just_pressed(STATE_ROLL):
        player_state = STATE_ROLL
        animated_sprite.play(STATE_ROLL)
    elif abs(velocity.x) > 0:
        player_state = STATE_SPRINT
        animated_sprite.play(STATE_SPRINT)
    else:
        player_state = STATE_IDLE
        animated_sprite.play(STATE_IDLE)

func _on_animation_finished(animation_name: String) -> void:
    if animation_name == STATE_ROLL:
        if is_on_floor():
            if abs(velocity.x) > 0:
                player_state = STATE_SPRINT
                animated_sprite.play(STATE_SPRINT)
            else:
                player_state = STATE_IDLE
                animated_sprite.play(STATE_IDLE)
        else:
            player_state = STATE_JUMP
            animated_sprite.play(STATE_JUMP)
    elif animation_name == STATE_DEATH:
        queue_free()

func die() -> void:
    player_state = STATE_DEATH
    animated_sprite.play(STATE_DEATH)
    velocity = Vector2.ZERO