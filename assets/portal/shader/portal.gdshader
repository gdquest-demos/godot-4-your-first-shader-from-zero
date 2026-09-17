shader_type canvas_item;

uniform float radius: hint_range(0.0, 0.5) = 0.4;
uniform float rim_width: hint_range(0.0, 0.3) = 0.05;

uniform float softness: hint_range(0.0, 0.2) = 0.01;

uniform float inner_gradient_start: hint_range(0.0, 0.5) = 0.1;
uniform float inner_gradient_width: hint_range(0.0, 0.5) = 0.2;

uniform vec3 inner_start_color: source_color = vec3(0.0, 0.0, 0.0);
uniform vec3 inner_end_color: source_color = vec3(0.02, 0.04, 0.51);

uniform vec3 rim_start_color: source_color = vec3(0.42, 0.40, 0.80);
uniform vec3 rim_end_color: source_color = vec3(0.23, 0.35, 0.65);

uniform float rim_gradient_width: hint_range(0.0, 0.5) = 0.05;

uniform float breathing_strength: hint_range(0.0, 0.1) = 0.03;
uniform float displacement_strength : hint_range(0.0, 0.2) = 0.05;

uniform vec2 noise_direction = vec2(0.8, 1.0);
uniform float noise_speed : hint_range(0.0, 1.0) = 0.1;

void fragment() {
  vec2 center = vec2(0.5, 0.5);

  vec2 sample_uv = UV + TIME * noise_direction * noise_speed;
  float noise_displacement = texture(TEXTURE, sample_uv).r;
  
  float oscillation = sin(TIME);

  float distance_from_center = 
    distance(UV, center) + 
    noise_displacement * displacement_strength +
    oscillation * breathing_strength;
  
  float mask_outer = smoothstep(
    radius, 
    radius - softness, 
    distance_from_center
  );

  float mask_inner = smoothstep(
    radius - rim_width, 
    radius - rim_width - softness, 
    distance_from_center
  );

  float mask_rim = mask_outer - mask_inner;

  float inner_gradient_factor = smoothstep(
    inner_gradient_start,
    inner_gradient_start + inner_gradient_width,
    distance_from_center
  );

  vec3 inner_gradient = mix(
    inner_start_color,
    inner_end_color,
    inner_gradient_factor
  );
  
  float rim_gradient_start = radius - rim_width;

  float rim_gradient_factor = smoothstep(
    rim_gradient_start,
    rim_gradient_start + rim_gradient_width,
    distance_from_center
  );

  vec3 rim_gradient = mix(
    rim_start_color,
    rim_end_color,
    rim_gradient_factor
  );

  vec3 final_color =
    mask_rim * rim_gradient +
    mask_inner * inner_gradient;

  COLOR = vec4(final_color, mask_outer);
}