varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 baseCol = v_vColour * texture2D(gm_BaseTexture,v_vTexcoord);
	//float value = dot(baseCol.rgb, vec3(0.3));
	//baseCol.a = (value - .3) * 5.;
	baseCol.a = dot(baseCol.rgb,vec3(.5));
	//baseCol.a = sign(abs(baseCol.b + baseCol.g - (baseCol.r * 2.)));
	
	gl_FragColor = baseCol;
}
