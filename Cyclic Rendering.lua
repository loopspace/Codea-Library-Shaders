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

//Default precision qualifier
precision highp float;

//This represents the current texture on the mesh
uniform lowp sampler2D source;
uniform lowp sampler2D target;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

vec2 red = vec2(1.,0.);
vec2 green = vec2(-.5,.5*sqrt(3.));
vec2 blue = vec2(-.5,-.5*sqrt(3.));

float order(vec4 a, vec4 b) {
    float r;
    vec2 ap = a.r*red + a.g*green + a.b*blue;
    vec2 bp = b.r*red + b.g*green + b.b*blue;
    vec2 apr = vec2(ap.y,-ap.x);
    r = dot(bp,apr);
    return step(0.,r);
}

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 cola = texture2D( source, vTexCoord );
    lowp vec4 colb = texture2D( target, vTexCoord );
    float r = order(cola,colb);
    lowp vec4 src = r*cola + (1.-r)*colb;
    lowp vec4 tgt = r*colb + (1.-r)*cola;
    lowp vec4 col;
    float a = 1. - (1.- src.a)*(1. - tgt.a);
    col.rgb = src.a*src.rgb/a + (1.-src.a/a)*tgt.rgb;
    col.a = a;
    col *= vColor;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Cyclic Rendering"] = getshader
end
    