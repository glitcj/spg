shader_type canvas_item;
render_mode blend_add;

varying vec4 v_tex;

void fragment() {
    v_tex = texture(TEXTURE, UV);
    COLOR = vec4(0.0, 0.0, 0.0, 1.0);
}

void light() {
    LIGHT = vec4(v_tex.rgb * LIGHT_COLOR.rgb, v_tex.a * LIGHT_ENERGY);
}