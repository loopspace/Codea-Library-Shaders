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
vec2 gr = 1./size;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    float x = 2.*vTexCoord.x - .5;
    float y = 2.*vTexCoord.y - .5;
    float u;
    float v;
    lowp vec4 col = vec4(0.,0.,0.,1.);
    // z^3 = x^3 - 3xy^2 
    u = x*x*x - 3.*x*y*y;
    v = 3.*x*x*y - y*y*y;
    col.x = .25*u + .5;
    col.y = .25*v + .5;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["PotentialFlow"] = getshader
end
    