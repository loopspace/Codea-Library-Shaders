local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;

//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
}

]],[[
//
// A basic fragment shader
//
highp float tpi = 2.* 3.1415926535897932384626433832795;
//Default precision qualifier
precision highp float;

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform highp vec2 centre;
uniform highp float innerRadius;
uniform highp float outerRadius;
uniform highp float rotation;
highp float rho = innerRadius/outerRadius;
highp float lrho = log2(rho);
highp float lra = log2(innerRadius)/lrho;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

highp float lengthsup (vec2 v) {
    return max(abs(v.x), abs(v.y));
}

highp float argsup (vec2 v) {
    return mix(v.y/v.x,2.-v.x/v.y,step(abs(v.x), abs(v.y))) + 4.*step(v.x,-v.y);
}

highp vec2 unitsup (float s) {
    s = fract((s+1.)/8.)*8. -1.;
    highp vec2 v = vec2(-clamp(2.-s,-1.,1.)*clamp(s-6.,-1.,1.), clamp(s,-1.,1.)*clamp(4.-s,-1.,1.));
    return v;
}

void main()
{
    highp vec2 t = (vTexCoord - centre)*2.;
    // highp float slen = tpi;
    highp float slen = 8.;
    // highp float r = length(t);
    highp float r = lengthsup(t);
    highp float lrr = log2(r)/lrho - lra;
    // highp float th = atan(t.y,t.x);
    highp float th = argsup(t);
    highp float n = ceil(lrr+th/slen);
    r = pow(rho,-fract(-(lrr + th/slen))+lra);
    th -= n*slen;
    th *= rotation;
    // t = vec2(cos(th),sin(th));
    t = unitsup(th);
    t *= r;
    th -= slen*rotation;
    r/=rho;
    // highp vec2 t1 = vec2(cos(th),sin(th));
    highp vec2 t1 = unitsup(th);
    t1*=r;
    t = t/2. + centre;
    t1 = t1/2. + centre;
    lowp vec4 col = texture2D( texture, t );
    lowp vec4 col1 = texture2D( texture, t1 );
    col.rgb = mix(col.rgb,col1.rgb,col1.a);
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Droste"] = getshader
end
    