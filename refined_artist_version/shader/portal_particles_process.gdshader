// This shader controls the radial particle motion. You can get a result that is
// close with the built-in particle material, but the artist working on this
// (heytibo) likes to customize the shader code to get the exact feel they are
// going for.
//
// Some of this shader code is copied straight from Godot's built-in particle
// material. Godot lets you save any of its built in materials as a to convert
// any of its built in materials to a shader to use as a base to edit.
//
// To convert a ParticleProcessMaterial to a shader, right-click the resource
// in the inspector and select "Convert to ShaderMaterial" from the drop-down
// menu.
shader_type particles;

uniform float portal_radius = 100.0;
uniform vec3 color : source_color = vec3(1.0);
uniform sampler2D alpha_curve;
uniform sampler2D emission_curve;

float rand_from_seed(in uint seed) {
	int k;
	int s = int(seed);
	if (s == 0) s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0) s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

vec2 random_dir(uint seed) {
	float angle = rand_from_seed(seed) * TAU;
	vec2 dir = vec2(cos(angle), sin(angle));
	return dir;
}

void start() {
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
	vec2 spawn_position = random_dir(alt_seed1) * portal_radius;
	float randomScale = 0.05 + rand_from_seed(alt_seed1) * 0.05;
	TRANSFORM[0] = EMISSION_TRANSFORM[0] * randomScale;
	TRANSFORM[1] = EMISSION_TRANSFORM[1] * randomScale;
	TRANSFORM[3].xy = EMISSION_TRANSFORM[3].xy + spawn_position;

	vec2 direction_to_center = normalize(EMISSION_TRANSFORM[3].xy - TRANSFORM[3].xy);
	vec2 direction_perpendicular_to_center = vec2(direction_to_center.y, -direction_to_center.x);
	VELOCITY = vec3(direction_perpendicular_to_center, 0.0) * 100.0;
	CUSTOM.y = 0.0;
}

void process() {
	CUSTOM.y += DELTA / LIFETIME;
	vec2 direction_to_center = normalize(TRANSFORM[3].xy - EMISSION_TRANSFORM[3].xy);
	VELOCITY.xy += -direction_to_center * 10.0;
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	float randomScale = 0.05 + rand_from_seed(alt_seed1) * 0.05;
	TRANSFORM[0] = EMISSION_TRANSFORM[0] * randomScale * (1.0 - CUSTOM.y);
	TRANSFORM[1] = EMISSION_TRANSFORM[1] * randomScale * (1.0 - CUSTOM.y);
	COLOR.rgb = color * texture(emission_curve, vec2(CUSTOM.y, 0.0)).x;
	COLOR.a = texture(alpha_curve, vec2(CUSTOM.y, 0.0)).x;
}
