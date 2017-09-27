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
uniform lowp sampler2D texture;
uniform vec2 size;
highp vec2 gr = 1./size;
uniform float dt ;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

lowp vec4 interp (lowp sampler2D t, highp vec2 p)
{
    highp vec2 q = floor(p*size/dt)*gr*dt;
    highp vec2 l = p - q;
    lowp vec4 c = (1. - l.x)*(1. - l.y)*texture2D( t, q);
    c +=  l.x*(1. - l.y)*texture2D( t, q + vec2(gr.x,0.));
    c +=  (1. - l.x)*l.y*texture2D( t, q + vec2(0.,gr.y));
    c +=  l.x*l.y*texture2D( t, q + gr);
    return c;
}

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = interp(texture,vTexCoord);


    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["ShaderTest"] = getshader
end
    