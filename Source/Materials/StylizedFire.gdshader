shader_type spatial;
render_mode unshaded;

uniform sampler2D noise_texture;

uniform sampler2D texture_mask;
uniform float emission_intensity = 2.0;
uniform float time_scale = 3.0;
uniform vec2 texture_scale = vec2(1.0);
uniform float edge_softness = 0.1;

varying vec3 world_coord;
varying float world_x_dot;
varying vec2 time_based_pan;

void vertex() {
	// billboard from godot generated (keep scale)
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	world_coord = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_coord = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec2 pan = vec2(-1.2, 0.5) * (-TIME * time_scale);
	//pan = vec2(VERTEX.z, VERTEX.y) * pan;
	time_based_pan = pan;
	time_based_pan.x *= sign(dot(VIEW_MATRIX[2].xyz, vec3(-1.0, 0.0, 0.0)));
	//time_based_pan = (INV_VIEW_MATRIX * vec4(0.0, pan.y, pan.x, 1.0)).xy;
}



void fragment() {
	ALBEDO = vec3(world_coord.y/3.0);
	float mask = texture(texture_mask, UV).r;


	float noise_xy = texture(noise_texture, world_coord.xy * texture_scale + time_based_pan).r;
	float noise_zy = texture(noise_texture, world_coord.zy * texture_scale + time_based_pan + vec2(0.7, 0.3)).r;

	float noise = mix(noise_xy, noise_zy, clamp(world_x_dot, 0.0, 1.0));

	ALBEDO = COLOR.rgb;
	EMISSION = ALBEDO * emission_intensity;

	float erosion_amount = (1.0 - COLOR.a);
	float alpha = (noise * mask) - erosion_amount;

	alpha = clamp(alpha, 0.0, 1.0);
	ALPHA = smoothstep(0.0, edge_softness, alpha);
}