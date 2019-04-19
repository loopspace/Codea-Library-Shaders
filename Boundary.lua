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
attribute float scale;
attribute vec2 offset;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying highp float vScale;
varying highp vec2 vOffset;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    vScale = scale;
    vOffset = offset;
    
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
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;
varying highp float vScale;
varying highp vec2 vOffset;

void main()
{
    //Sample the texture at the interpolated coordinate
    highp vec2 pos = vTexCoord + vOffset * gr;
    lowp vec4 col = texture2D( texture, pos );
    col.xy *= vScale;
    col.xy += (1.-vScale) * vec2(.5,.5);
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader
else
    shaders["Boundary"] = getshader
end
    