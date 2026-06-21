shader_type canvas_item;
render_mode blend_mix;
uniform float progress   : hint_range(0.0, 1.0)   = 0.0;
uniform vec4  tint       : source_color            = vec4(1.0, 0.5, 1.0, 1.0);
uniform float wave_amp   : hint_range(0.0, 0.1)   = 0.03;
uniform float wave_freq  : hint_range(1.0, 20.0)  = 8.0;
uniform float wave_phase : hint_range(0.0, 100.0) = 10.0;
uniform float frame_size : hint_range(0.0, 1028.0) = 48.0;
uniform bool run_vertex;
uniform bool run_fragment; // uniform bools are safe to branch on — same value for every fragment, whole warp takes the same path, no divergence
uniform sampler2D noise_tex;
uniform float noise_scale  : hint_range(0.1, 5.0) = 1.0;
uniform float noise_speed  : hint_range(0.0, 2.0) = 0.2;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.4;
uniform bool time_as_progress = true ;
uniform float speed: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float angle : hint_range(0.0, 3.14 * 2., 0.0) = 0.0 ;


vec4 black_as_transparent(vec4 _pixel) {
	// vec4 value = _pixel ;
	// value.a = mix(0., 1.,  step(0.1, distance(_pixel.rgb, vec3(0.,0.,0.))) ) ;
	// _pixel.a = length(_pixel.rgb) ;
	_pixel.a = length(_pixel.rgb) ;
	return _pixel ;
	//return value ;
	
}

vec4 filled_circle(vec2 _centered_uv, float radius) {
	vec4 filled_circle = vec4(1.) ;
	
	filled_circle.rgb = vec3(distance(_centered_uv, vec2(0., 0.))) ;
	filled_circle.rgb = step(radius, filled_circle.rgb) ;
	
	
	filled_circle.rgb = vec3(1.) - filled_circle.rgb ;
	filled_circle = black_as_transparent(filled_circle) ;
	return filled_circle ;
	
} 



vec2 _center(vec2 _uv) {
	return _uv ;
	}

vec2 _rotate(vec2 _uv, float _angle) {
	mat3 rotation = mat3(vec3(cos(angle), -sin(angle), 0.), vec3(sin(angle), cos(angle), 0.), vec3(0., 0., 1.));
	return (rotation * vec3(_uv, 1.)).xy   ;

}
vec2 _translate(vec2 _uv, vec2 offset) {
	mat3 translation = mat3( 
		vec3(1., 0., 0.), 
		vec3(0., 1., 0.), 
		vec3(offset.x, offset.y, 1.)
		) ;
	return (translation * vec3(_uv, 1.)).xy ;
}

vec2 _scale(vec2 _uv) {
	return _uv ;
}

vec2 _scroll(vec2 _uv) {
	return vec2(1.) ;
}

vec4 filled_ellipse(vec2 _centered_uv, vec2 radius, bool hard) {	
	
	
	// draw ellipse
	vec4 filled_ellipse = vec4(1.) ;
	filled_ellipse.rgb = vec3(length((_centered_uv - vec2(0., 0.)) / radius )) ;
	filled_ellipse.rgb = vec3(1.) - filled_ellipse.rgb ;
	filled_ellipse.rgb = max(vec3(0.), filled_ellipse.rgb) ; // clamp negative values from ellipse equation
	
	// apply hard edge
	vec4 hard_filled_ellipse = step(0.5, filled_ellipse) ;
	filled_ellipse = mix(filled_ellipse, hard_filled_ellipse,  float(hard)) ;
	
	// remove background
	filled_ellipse = black_as_transparent(filled_ellipse) ;	
	
	return filled_ellipse;
	
} 


vec4 _stack() {return vec4(0.) ;}

void vertex() {}
void fragment() {
	vec4 texel = texture(TEXTURE, UV);
	vec4 pixel = vec4(0.) ;
	vec4 noxel ;
	vec2 centered_uv = UV * 2. - 1. ;
	vec2 cartesian_uv = vec2(centered_uv.x, -centered_uv.y ) ;
	
	// Using ifs on uniform variables is GPU friendly, because all pixels will follow exactly the same instruction path.
	// if (!run_fragment) { 
	if (true) { 
		vec4 noxel_octave_1 = texture(noise_tex, vec2( fract(UV.x + TIME / (1./speed)) , UV.y));
		vec4 noxel_octave_2 = texture(noise_tex, vec2( fract(UV.x + TIME / (1./speed)) , fract(UV.y + .5) ));
		noxel = noxel_octave_1 ;
		
		float slope = 1. ;
		// no divergence here — every fragment runs the same multiply, just with a different value of centered_uv.x
		// divergence is about which instructions run, not what values they produce
		// float function_at_x = slope * cartesian_uv.x ;
		// float function_at_x = sin(5. * cartesian_uv.x) ;
		float function_at_x = tan(cartesian_uv.x) ;
		
		// float function_at_x = -1. - tan(cartesian_uv.x) * 1. ;
		// float function_at_x = cartesian_uv.x ;
		
		pixel.a = 1. ;
		// ⚠ this if causes warp divergence — fragments near the line take a different code path than fragments far from it
		// the GPU runs both sides of the branch for the whole warp and masks out the irrelevant results, wasting work
		// branchless equivalent: pixel.rgb = vec3(1.0 - step(0.02, abs(centered_uv.y - function_at_x)));
		// or with smooth anti-aliased edge: pixel.rgb = vec3(1.0 - smoothstep(0.01, 0.02, abs(centered_uv.y - function_at_x)));
		// step/smoothstep convert the distance into a value — same instruction for every fragment, no split code paths
		// if (abs(centered_uv.y - function_at_x) < 0.02) pixel.rgb = vec3(1.) ;


		// ⚠ divergent — fragments split into two code paths, GPU runs both and masks results
		// if (abs(centered_uv.y - function_at_x) < 0.02) pixel.rgb = vec3(1.) ;
		// branchless — distance becomes a value, one instruction stream for all fragments
		// pixel.rgb = vec3(1.0 - smoothstep(0.01, 0.02, abs(cartesian_uv.y - function_at_x)));
		// pixel.rgb = vec3(1.0 - step(0.05,  abs(cartesian_uv.y - function_at_x)));
		// pixel.rgb = vec3(1.0 - abs(cartesian_uv.y - function_at_x));
		
		vec2 _circle_uv = _translate(_rotate(centered_uv, angle), vec2(0.1, 0.1)) ;
		vec2 _ellipse_uv =  _translate(_rotate(centered_uv, angle), vec2(0.1, 0.1)) ;
		
		
		
		vec4 circle_1 = filled_circle(_circle_uv, .2) ;
		vec4 ellipse_1 = filled_ellipse(_ellipse_uv, vec2(1., 2.), false) ;
		pixel = circle_1 ;
		// pixel = ellipse_1 ;
		
		pixel = mix(ellipse_1, circle_1, circle_1.a) ;
		// pixel = mix(pixel, ellipse_1, ellipse_1.a) ;
		// pixel = ellipse_1 + circle_1 ;
		
		// pixel = filled_circle(_circle_uv, vec2(0.1, 0.1), .2) ;
		// pixel += filled_ellipse(_ellipse_uv, vec2(0., 0.), vec2(1., 2.)) ;
		
		
		
		// pixel = mix(circle_1, ellipse_1, circle_1.a) ;
		
		
		
	}
	COLOR = pixel ;
}