shader_type canvas_item;
render_mode blend_mix;

uniform float progress   : hint_range(0.0, 1.0)   = 0.0;
uniform vec4  tint       : source_color            = vec4(1.0, 0.5, 1.0, 1.0);
uniform float wave_amp   : hint_range(0.0, 0.1)   = 0.03;
uniform float wave_freq  : hint_range(1.0, 20.0)  = 8.0;
uniform float wave_phase : hint_range(0.0, 100.0) = 10.0;
uniform float frame_size : hint_range(0.0, 1028.0) = 48.0;

uniform bool run_vertex;
uniform bool run_fragment;

// --- Add these ---
uniform sampler2D noise_tex;                              // assign a NoiseTexture2D here
uniform float noise_scale  : hint_range(0.1, 5.0) = 1.0; // zoom level of noise
uniform float noise_speed  : hint_range(0.0, 2.0) = 0.2; // scroll speed
uniform float noise_strength : hint_range(0.0, 1.0) = 0.4; // how visible the noise is

uniform bool time_as_progress = true ;
uniform float speed: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float angle : hint_range(0.0, 3.14 * 2., 0.0) = 0.0 ;

varying vec2 varying_vertex ;

void vertex() { 
	// in vertex(), VERTEX is in (0, 1) space, refers to the position of the *vertex* in vertex space
	// in vertex(), COLOR is the *modulate* of the "fragment after rasterisation ?", not the absolute colour
	VERTEX.x += sin(UV.y * 10. + TIME) ;
	varying_vertex = VERTEX ;
	COLOR.rg += VERTEX / 100. ; // in vertex(), COLOR is a modulate colour, not pixel colour.
}

void fragment() {
	// in fragment(), VERTEX is in texture dimensions space (e.g. goes from 0 to 32 in a 32x32 texture)
	// in fragment(), VERTEX is a vector referring to the position of the *fragment* in texture space
	// in fragment(), COLOR is the absolute colour of the fragment
	// COLOR.rg = varying_vertex / (1./TEXTURE_PIXEL_SIZE);
}

