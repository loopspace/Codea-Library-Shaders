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
uniform lowp sampler2D position;
uniform lowp sampler2D velocity;
uniform float DeltaTime;
uniform float scale;
uniform float friction;
uniform vec2 gravity;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    
    lowp vec4 p = texture2D( position, vTexCoord );
    lowp vec4 v = texture2D( velocity, vTexCoord );
    lowp vec2 u = v.xy - vec2(.5);
    float l = length(u);
    v.xy += scale*DeltaTime * (gravity - friction * l * u);
    if (p.x < .05 && v.x < .5)
        v.x = 1. - v.x;
    if (p.x > .95 && v.x > .5)
        v.x = 1. - v.x;
    if (p.y < .05 && v.y < .5)
        v.y = 1. - v.y;
    if (p.y > .95 && v.y > .5)
        v.y = 1. - v.y;
    //Set the output color to the texture color
    gl_FragColor = v;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Particle Velocity"] = getshader
end
    