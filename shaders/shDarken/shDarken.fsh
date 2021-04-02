varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 baseCol = v_vColour * texture2D(gm_BaseTexture,v_vTexcoord);
	baseCol.a = 1.-baseCol.a;
	baseCol.a *= .25;
	
	gl_FragColor = vec4(vec3(0.),baseCol.a);
}
