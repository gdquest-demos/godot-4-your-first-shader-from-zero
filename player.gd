extends CharacterBody2D

@export var movement_speed := 450.0
@export var turn_speed := 4.0


func _physics_process(delta: float) -> void:
	var turn_input := Input.get_axis("ui_left", "ui_right")
	rotation += turn_input * turn_speed * delta

	var thrust := Input.get_axis("ui_up", "ui_down")
	velocity = transform.y * thrust * movement_speed

	move_and_slide()
