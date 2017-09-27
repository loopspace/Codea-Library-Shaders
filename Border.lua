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
uniform float width;
uniform float antialias;
float b = width - antialias/2.;
float c = width + antialias/2.;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = texture2D( texture, vTexCoord ) * vColor;
    float s = smoothstep(b,c,vTexCoord.x) * (1. - smoothstep(1.- c,1.-b, vTexCoord.x)) *
    smoothstep(b,c,vTexCoord.y) * (1. - smoothstep(1.-c,1.-b,vTexCoord.y));
    col.xyz*=s;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Border"] = getshader
end
    