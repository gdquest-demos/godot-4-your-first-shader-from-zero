extends ColorRect

@onready var mat : ShaderMaterial = material

func _process(_delta):
	var camera_2d : Camera2D = get_viewport().get_camera_2d()
	if camera_2d == null: return
	mat.set_shader_parameter("view_offset", camera_2d.get_screen_center_position())
