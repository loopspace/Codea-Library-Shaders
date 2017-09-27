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
    vTexCoord = vec2(texCoord.x, 1.0 - texCoord.y);
    
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
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
lowp float wire = 0.1;
lowp float border = 0.03;

void main()
{
    if (vTexCoord.x > wire && vTexCoord.x < 1. - wire && vTexCoord.y > wire && vTexCoord.y < 1. - wire) {
        discard;
    } else {
    if (vTexCoord.x > border && vTexCoord.x < 1. - border && vTexCoord.y > border && vTexCoord.y < 1. - border) {
        gl_FragColor = vColor;
        //discard;

    } else {
    //Set the output color to the texture color
        gl_FragColor = vec4(0.,0.,0.,1.);
        }
    }
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Wireframe"] = getshader
end
    