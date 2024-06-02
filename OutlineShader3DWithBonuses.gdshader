shader_type spatial;
render_mode unshaded;

uniform sampler2D sprite_texture : filter_nearest, repeat_disable;
uniform vec3 outlineColor : source_color = vec3(1.0,1.0,1.0);
uniform float lineWeight = 3.0;

void vertex() {
	UV=UV;
	// billboard the mesh
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0],INV_VIEW_MATRIX[1],INV_VIEW_MATRIX[2],MODEL_MATRIX[3]);
}

float mask(vec2 point){
	return mix(0., 1., texture(sprite_texture, point).a);
}

void fragment() {
	float dx = (1.0 / float(textureSize(sprite_texture, 0).x)) * (lineWeight - 1.) * (1. + sin(TIME + UV.x * 4.) * .5);
	float dy = (1.0 / float(textureSize(sprite_texture, 0).y)) * (lineWeight - 1.) * (1. + sin(TIME + UV.y * 6.) * .5);
	
	vec2 uvCenter   = UV;
	float maskCenter   = mask(uvCenter);
	float delta = 0.0;
	for(float i = -1.; i<2.; i++){
		for(float j = -1.; j<2.; j++){
			vec2 point = vec2(uvCenter.x + (i * dx), uvCenter.y + (j * dy));
			float maskAtPoint = mask(point);
			float diffAtPoint = abs(maskCenter - maskAtPoint);
			delta = max(delta, diffAtPoint);
		}
	}
	float thresh = step(.5, delta);
	
	vec3 finColor = thresh * ( outlineColor);

	float weirdValueX = .2 * (sin(TIME + UV.x * 8.));
	float weirdValueY = .5 * (sin(TIME + UV.y * 8.));
	vec4 outline = vec4(finColor.r + weirdValueX, finColor.g - weirdValueY, finColor.b + (.5 * weirdValueX), 1.0);
	vec4 albedo  = texture(sprite_texture, UV);

	ALBEDO = mix(albedo, outline, thresh).rgb;
	ALPHA = clamp(albedo.a + thresh, 0., 1.);
}

