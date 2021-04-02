varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 baseCol = v_vColour * texture2D(gm_BaseTexture,v_vTexcoord);
    
    float brightness = dot(baseCol.rgb, vec3(0.299, 0.587, 0.114) * .9);
    //baseCol.rgb = vec3(brightness);
    
    float midtones = brightness + .5;
    midtones = midtones > 1. ? midtones - (fract(midtones) * 5.) : midtones;
    midtones = max(midtones-.3,0.);
    vec3 addedContrast = (vec3(brightness)-.5)*(1.+(1.2*midtones-((1.-midtones)*.7)))+.5;
    baseCol.rgb = mix(addedContrast,baseCol.rgb,.2);
    baseCol.rg += vec2(.05,.02);
    
    gl_FragColor = baseCol;
}