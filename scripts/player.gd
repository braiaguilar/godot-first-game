extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
var jump_counter = 0
var current_speed = SPEED
var is_rolling = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Conectamos la señal animation_finished al script.
	animated_sprite.connect("animation_finished", self, "_on_animation_finished")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * 1.2) * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_counter < 2:
		velocity.y = JUMP_VELOCITY
		jump_counter += 1

	if is_on_floor() and jump_counter >= 2:
		jump_counter = 0

	# Sprint.
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		current_speed = SPEED * 1.6
	if Input.is_action_just_released("sprint"):
		current_speed = SPEED

	# Handle movement.
	var direction := Input.get_axis("move_left", "move_right")

	if direction == -1:
		animated_sprite.flip_h = true
	if direction == 1:
		animated_sprite.flip_h = false

	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	# Animations.
	if not is_rolling:
		if is_on_floor():
			if Input.is_action_just_pressed("roll"):
				is_rolling = true
				animated_sprite.play("roll")
			elif direction:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
		else:
			animated_sprite.play("air")

	move_and_slide()

func _on_animation_finished() -> void:
	# Detectar cuando termine la animación "roll".
	if animated_sprite.animation == "roll":
		is_rolling = false
