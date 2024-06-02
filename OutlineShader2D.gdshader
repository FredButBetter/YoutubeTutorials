shader_type canvas_item;
render_mode unshaded;

uniform vec3 outlineColor : source_color = vec3(.0,.0,.0);
uniform float lineWeight = 1.0;

float mask(vec2 point, sampler2D text){
	return mix(0., 1., texture(text, point).a);
}

void fragment() {
	float dx = (1.0 / float(textureSize(TEXTURE, 0).x)) * lineWeight / 2.;
	float dy = (1.0 / float(textureSize(TEXTURE, 0).y)) * lineWeight / 2.;

	vec2 uvCenter   = UV;
	float maskCenter   = mask(uvCenter, TEXTURE);
	float delta = 0.0;
	for(float i = -1.; i<2.; i++){
		for(float j = -1.; j<2.; j++){
			vec2 point = vec2(uvCenter.x + (i * dx), uvCenter.y + (j * dy));
			float maskAtPoint = mask(point, TEXTURE);
			float diffAtPoint = abs(maskCenter - maskAtPoint);
			delta = max(delta, diffAtPoint);
		}
	}
	float thresh = step(.5, delta);
	
	vec3 finColor = step(0.5, delta) * ( outlineColor);

	vec4 outline = vec4(finColor, 1.0);
	vec4 albedo  = texture(TEXTURE, UV);

	COLOR.rgb = mix(albedo, outline, thresh).rgb;
	COLOR.a = clamp(albedo.a + thresh, 0., 1.);
}


