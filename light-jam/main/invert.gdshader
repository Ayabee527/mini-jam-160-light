shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR.rgb = vec3(1.0) - texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
}
