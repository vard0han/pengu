shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width: hint_range(0.0, 4.0) = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 current_pixel = texture(TEXTURE, UV);
	
	if(current_pixel.a > 0.0){
		COLOR = current_pixel;
	} else {
		vec2 step_size = outline_width / vec2(textureSize(TEXTURE, 0));
		
		float neighbor_alpha = 0.0;
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV + vec2(step_size.x, 0.0)).a);
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV - vec2(step_size.x, 0.0)).a);
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV + vec2(0.0, step_size.y)).a);
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV - vec2(0.0, step_size.y)).a);
		
		if (neighbor_alpha > 0.0) {
			COLOR = outline_color;
		} else {
			COLOR = current_pixel;
		}
	}
}
