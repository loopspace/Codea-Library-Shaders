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
uniform lowp sampler2D source;
uniform lowp sampler2D target;
uniform float alpha;
uniform float beta;
uniform vec2 size;
highp float rbeta = 1./beta;
highp vec2 gr = 1./size;
highp vec4 offset = ((-2. - .5*alpha)*rbeta + .5)*vec4(1.,1.,0.,0.);
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    highp vec4 xL = texture2D( source, vTexCoord - vec2(gr.x,0.));
    highp vec4 xR = texture2D( source, vTexCoord + vec2(gr.x,0.));
    highp vec4 xB = texture2D( source, vTexCoord - vec2(0.,gr.y));
    highp vec4 xT = texture2D( source, vTexCoord + vec2(0.,gr.y));
    highp vec4 bC = texture2D( target, vTexCoord );
    highp vec4 col = (xL + xR + xB + xT + alpha * bC) * rbeta + offset;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Jacobi"] = getshader
end
    