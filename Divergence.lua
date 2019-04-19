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
uniform lowp sampler2D velocity;
uniform vec2 size;
vec2 gr = 1./size;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    mediump vec4 xL  = texture2D( velocity, vTexCoord - vec2(gr.x,0.));
    mediump vec4 xR  = texture2D( velocity, vTexCoord + vec2(gr.x,0.));
    mediump vec4 xB  = texture2D( velocity, vTexCoord - vec2(0.,gr.y));
    mediump vec4 xT  = texture2D( velocity, vTexCoord + vec2(0.,gr.y));

    mediump float div = ((xR.x - xL.x ) + (xT.y - xB.y))*.5;
    // div is in the range [-1,1] so we shift to [0,1]
    // need a factor of 2/deltaX to compensate for the scaling
    div *= .5;

    div += .5;
    lowp vec4 col = vec4(div,0.,0.,1.);
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader
else
    shaders["Divergence"] = getshader
end
    