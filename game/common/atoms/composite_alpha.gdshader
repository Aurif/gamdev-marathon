shader_type canvas_item;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    tex_color.a *= tex_color.r; // Multiply alpha by red channel
    COLOR = tex_color;
}