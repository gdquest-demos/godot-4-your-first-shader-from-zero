// This is the shader of the central part of the portal.
//
// It uses one important technique that's different from the reference course:
// polar coordinates. Concretly, the shader converts the UV coordinates into
// a radius and angle, allowing us to create radial patterns and animate them.
//
// See the file polar_coordinate.gdshaderinc for the polar_coordinates function.
shader_type canvas_item;

uniform sampler2D gradient: source_color;
uniform float portal_radius: hint_range(0.0, 0.5, 0.05) = 0.4;

uniform float breathing_strength: hint_range(0.0, 0.1) = 0.03;
uniform float displacement_strength : hint_range(0.0, 0.2) = 0.05;

uniform float noise_speed : hint_range(0.0, 1.0) = 0.1;

#include "polar_coordinate.gdshaderinc"

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	float time = TIME * noise_speed;
	vec2 sample_uv = polar_coordinates(UV, center, 1.0, 1.0);
	float noise_displacement = texture(TEXTURE, vec2(
		sample_uv.x - time + sample_uv.y * 2.0,
		sample_uv.y - time + sample_uv.x * 1.0)
	).r;

	float noise_displacement_2 = texture(TEXTURE, vec2(
		sample_uv.x - time * 2.0 + sample_uv.y * 4.0,
		sample_uv.y + time * 2.0 + sample_uv.x * 3.0)
	).r;

	float oscillation = sin(TIME);

	float distance_from_center =
		distance(UV, center) +
		(noise_displacement + noise_displacement_2 * 0.5) * displacement_strength +
		oscillation * breathing_strength;

	COLOR.rgba = texture(
		gradient,
		vec2((distance_from_center / portal_radius) - 0.1
		+ smoothstep(0.4, 0.8, noise_displacement_2) * 0.1
		, 0.0)).rgba;
}
