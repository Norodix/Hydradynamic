shader_type spatial;
render_mode cull_front, unshaded;

uniform vec4 outline_color : source_color;
uniform float outline_width = 1.0;
uniform float offset_limit = 1.0;

void vertex() {
	// position in clip space
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	// normal in clip space
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);
	// VIEWPORT_SIZE = Size of viewport (in pixels).
	// projection matrix remaps the space defined by the viewing frustum to a unit cube
	// multiply by clip_position.w is needed to unproject vector.... maybe?
	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;
	
	clip_position.xy += offset;
	POSITION = clip_position; // overwrites vertex position after projections
}

void fragment() {
	ALBEDO = outline_color.rgb;
	if (outline_color.a < 1.0) {
		ALPHA = outline_color.a;
	}
}
