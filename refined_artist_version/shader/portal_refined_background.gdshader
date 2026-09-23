// This shader is similar to the portal shader, but with some transparency, and
// it also samples from pixels rendered to the screen to deform the space
// background.
//
// See the screen_sampler uniform and the screen_color variables to learn how to
// sample from the screen texture.
shader_type canvas_item;

uniform sampler2D screen_sampler: hint_screen_texture;
uniform sampler2D gradient: source_color;
uniform float portal_radius: hint_range(0.0, 0.5) = 0.4;
uniform float softness: hint_range(0.0, 0.2) = 0.01;

#include "polar_coordinate.gdshaderinc"

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	vec2 sample_uv = polar_coordinates(UV, center, 1.0, 1.0);
	float noise_displacement = texture(TEXTURE, vec2(
		sample_uv.x + sample_uv.y * 2.0,
		sample_uv.y * 2.0 - TIME * 0.15)
	).r;
	float distance_from_center = distance(UV, center) + noise_displacement * 0.2;
	float mask_outer = smoothstep(
		portal_radius,
		portal_radius - softness,
		distance_from_center
	);
	float normalized_noise = (noise_displacement - 0.5) * 2.0;
	vec3 screen_color = texture(screen_sampler, SCREEN_UV + normalized_noise * 0.025 * mask_outer).rgb;
	vec4 noise_color = texture(gradient, vec2(noise_displacement, 0.0)).rgba;
	COLOR.rgb = mix(screen_color, noise_color.rgb, noise_color.a * mask_outer);
}
