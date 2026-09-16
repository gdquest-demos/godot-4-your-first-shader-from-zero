extends Node

func _ready() -> void:
	var t: SceneTreeTimer = get_tree().create_timer(4.0)
	t.timeout.connect(get_tree().quit)
