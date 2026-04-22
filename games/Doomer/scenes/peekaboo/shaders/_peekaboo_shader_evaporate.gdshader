shader_type canvas_item;

uniform float evaporate_progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 edge_color : source_color = vec4(0.6, 0.9, 1.0, 1.0);
uniform float edge_width : hint_range(0.0, 0.3) = 0.08;
uniform float noise_scale : hint_range(1.0, 20.0) = 6.0;
uniform float rise_speed : hint_range(0.0, 5.0) = 1.2;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float smooth_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 4; i++) {
        v += a * smooth_noise(p);
        p *= 2.1;
        a *= 0.5;
    }
    return v;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Noise drifts upward over time (UV.y decreases = up in Godot canvas)
    vec2 noise_uv = UV * noise_scale + vec2(0.0, -TIME * rise_speed);
    float n = fbm(noise_uv);

    // UV.y = 0 is top, 1 is bottom — top evaporates first
    // bias makes upper pixels hit the threshold sooner
    float bias = (1.0 - UV.y) * 0.4;
    float threshold = evaporate_progress - bias;

    // Hard dissolve cutoff
    float dissolve = step(threshold, n);

    // Soft glowing edge just at the dissolve boundary
    float inner = threshold;
    float outer = threshold + edge_width;
    float edge = smoothstep(inner, mix(inner, outer, 0.5), n)
               * (1.0 - smoothstep(mix(inner, outer, 0.5), outer, n));

    vec4 final_color = tex_color;
    // Apply edge glow only where the sprite is still visible
    final_color.rgb = mix(final_color.rgb, edge_color.rgb, edge * edge_color.a);
    final_color.a = tex_color.a * dissolve;

    COLOR = final_color;
}