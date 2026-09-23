// This function takes Cartesian UV coordinates (x goes right and y goes down)
// and turns them into polar coordinates (coordinates expressed in terms of radius and angle).
//
// This allows us create radial patterns and animate them.
//
// Credits: Adapted from https://godotshaders.com/snippet/polar-coordinates/
vec2 polar_coordinates(vec2 uv, vec2 pivot_point, float zoom, float texture_repeat_count) {
	vec2 pivot_to_uv = uv - pivot_point;
	float radius = length(pivot_to_uv) * 2.0;

	float turns_from_pivot = atan(pivot_to_uv.y, pivot_to_uv.x) / TAU;
	vec2 scaled_coordinates = vec2(radius * zoom, turns_from_pivot * texture_repeat_count);
	vec2 wrapped_coordinates = mod(scaled_coordinates, 1.0);
	return wrapped_coordinates;
}
