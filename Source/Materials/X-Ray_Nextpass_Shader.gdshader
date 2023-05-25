shader_type spatial;
render_mode depth_test_disabled, blend_add, cull_disabled;

uniform bool active = true;
uniform sampler2D noise : hint_default_white;
uniform sampler2D gradient : hint_default_white;

void fragment() {
	float noise_a = texture(noise, UV * 0.5).r;
	float gradient_a = pow(texture(gradient, UV2 * 0.9).r, 2.0);
	
	ALBEDO = vec3(0.5,0.5,1.0);
	ALPHA = clamp(float(active) * noise_a * gradient_a * 0.5, 0.0, 0.5);
	//ALPHA_HASH_SCALE = 2.0;
}
