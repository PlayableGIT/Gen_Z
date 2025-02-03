shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float density = 0.3;
uniform vec2 speed = vec2(0.1, 0.05);
uniform vec4 fog_color : source_color = vec4(0.5, 0.6, 0.7, 1.0);

void fragment() {
    vec2 uv = UV + speed * TIME;
    float noise = texture(noise_texture, uv).r;
    float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
    COLOR = fog_color;
    COLOR.a = fog * density;
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
