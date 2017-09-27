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

uniform float yScale;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = vec2(texCoord.x, 1.0 - texCoord.y);
    vec4 pos = position;
    pos.y = yScale*pos.y;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * pos;
}

]],[[
//
// A basic fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = texture2D( texture, vTexCoord );

    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Stretch"] = getshader
end
    