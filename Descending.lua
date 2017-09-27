local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;
uniform float time;
//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec2 velocity;
attribute vec2 origin;
attribute float itime;
attribute float angvel;
attribute float angle;


//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    highp float a = angle + (time - itime)*angvel;
    highp vec2 v = position.xy - origin;
    highp vec4 p = position;
    p.xy = origin + (time-itime)*velocity;
    p.x += cos(a)*v.x + sin(a)*v.y;
    p.y += -sin(a)*v.x + cos(a)*v.y;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * p;
}

]],[[
//
// A basic fragment shader
//

//Default precision qualifier
precision highp float;

//This represents the current texture on the mesh
uniform lowp sampler2D texture;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = texture2D( texture, vTexCoord ) * vColor;

    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Descending"] = getshader
end
    