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


void vertex() {}

void fragment() {
	vec4 texel = texture(TEXTURE, UV);
	vec4 pixel = vec4(1.) ;
	vec4 noxel ;
	vec2 centered_uv = UV * 2. - 1. ;
	
	vec4 noxel_octave_1 =  texture(noise_tex, vec2(  fract(UV.x + TIME / (1./speed)) , UV.y));
	vec4 noxel_octave_2 =  texture(noise_tex, vec2(  fract(UV.x + TIME / (1./speed)) , fract(UV.y + .5)  ));
	noxel = noxel_octave_1 ; // + noxel_octave_2
	
	float slope = tan(angle) ;
	
	// pixel.rgb = vec3(centered_uv.y -  slope * centered_uv.x) ;
	
	pixel.rgb = vec3(centered_uv.y -  centered_uv.x ) ;
	// pixel.rgb = vec3(centered_uv.y) ;
	
	// at UV.x = -1 (-1 - (-1)) to (+1 - (-1))
	// at UV.x = +1 (-1 - (+1)) to (+1 - (+1))
	
	// f(x, y) = 
	// f(0, 0) = grey
	// f(0, .2) = grey
	// f(0, -.2) = grey
	// f(0, -.5) = white
	// f(0, .5) = black
	
	
	// slope fixed with any value of  x or y
	// with higher y pixel transitions from black to white
	// higher x means y transitions earlier

	
	COLOR = pixel ;
}

