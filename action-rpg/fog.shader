shader_type canvas_item;

uniform vec3 color = vec3(0.01, 0.2, 0.01);
uniform int OCTAVES = 1;

float rand(vec2 coord) {
	return fract(sin(dot(coord, vec2(12.9898, 78.233)) * 1000.0) * 43758.5453);
}

float noise(vec2 coord) {
	vec2 integer = floor(coord);
	vec2 fraction = fract(coord);
	
	float top_left = rand(integer);
	float top_right = rand(integer + vec2(1.0, 0.0));
	float bottom_left = rand(integer + vec2(0.0, 1.0));
	float bottom_right = rand(integer + vec2(1.0, 1.0));
	
	vec2 cubic_frac = fraction * fraction * (3.0 - 2.0 * fraction); 
	// using fraction instead of cubic_frac works just fine in this case, but I'm keeping cubic_frac for learning purposes.
	float noise = mix(top_left, top_right, cubic_frac.x) + (bottom_left - top_left) * cubic_frac.y * (1.0 - cubic_frac.x) + (bottom_right - top_right) * cubic_frac.x * cubic_frac.y;
	return noise;
}

float fractal_brownian_motion(vec2 coord) {
	float value = 0.0;
	float scale = 0.5;
	float normalize_factor = 0.0;
	
	for(int i = 0; i < OCTAVES; i++) {
		value += noise(coord) * scale;
		normalize_factor += scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value / normalize_factor;
}

void fragment() {
	vec2 coord = UV * 100.0;

	vec2 motion = vec2(fractal_brownian_motion(coord + TIME * 0.3));
	float fbm = fractal_brownian_motion(coord + motion);
	COLOR = vec4(color, fbm);
}