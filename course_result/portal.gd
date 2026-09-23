extends Area2D

var tween: Tween = null

@onready var _material: ShaderMaterial = $Sprite2D.material


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		_animate_portal(0.45, 0.03, 0.07)


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		_animate_portal(0.12, 0.00, 0.15)


func _animate_portal(
	radius: float,
	breathing_strength: float,
	displacement_strength: float,
) -> void:
	if tween != null:
		tween.kill()

	tween = create_tween().set_parallel()
	tween.set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(
		_material,
		"shader_parameter/radius",
		radius,
		0.5,
	)
	tween.tween_property(
		_material,
		"shader_parameter/breathing_strength",
		breathing_strength,
		0.5,
	)
	tween.tween_property(
		_material,
		"shader_parameter/displacement_strength",
		displacement_strength,
		0.5,
	)
