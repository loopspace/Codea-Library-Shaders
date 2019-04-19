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
uniform lowp sampler2D texture1;
uniform lowp sampler2D texture2;
uniform lowp sampler2D texture3;
uniform lowp sampler2D texture4;
uniform lowp sampler2D texture5;
uniform lowp sampler2D texture6;
uniform lowp sampler2D texture7;
uniform lowp sampler2D texture8;

uniform float weight[8];
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    highp vec4 col1 = texture2D( texture1, vTexCoord );
    highp vec4 col2 = texture2D( texture2, vTexCoord );
    highp vec4 col3 = texture2D( texture3, vTexCoord );
    highp vec4 col4 = texture2D( texture4, vTexCoord );
    highp vec4 col5 = texture2D( texture5, vTexCoord );
    highp vec4 col6 = texture2D( texture6, vTexCoord );
    highp vec4 col7 = texture2D( texture7, vTexCoord );
    highp vec4 col8 = texture2D( texture8, vTexCoord );
    
    highp vec4 col = col1 * weight[0] + col2 * weight[1] + col3 * weight[2] + col4 * weight[3] + col5 * weight[4] + col6 * weight[5] + col7 * weight[6] + col8 * weight[7];

    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader
else
    shaders["Affine"] = getshader
end
    