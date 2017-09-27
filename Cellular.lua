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

uniform int rules[8];
uniform float width;
float rw = 1./width;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

int parents(float x)
{
    int v = 0;
    v += int( texture2D(texture,vec2(x-rw,.5)).r);
    v += 2*int( texture2D(texture,vec2(x,.5)).r);
    v += 4*int( texture2D(texture,vec2(x+rw,.5)).r);
    return v;
}

void main()
{
    //Sample the texture at the interpolated coordinate
    int i = parents(vTexCoord.x);
    vec4 col = vec4(0.);
    col.r = float( rules[i]);
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Cellular"] = getshader
end
    