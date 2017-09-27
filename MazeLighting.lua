local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;
uniform mat4 model;
uniform vec3 origin;
vec4 porigin = vec4(origin,1.);

//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec4 normal;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying highp vec4 vNormal;
varying highp vec4 vPosition;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    vNormal = normalize(model * normal);
    vPosition = model * position - porigin;
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
uniform mediump float scale;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;
varying highp vec4 vPosition;
varying highp vec4 vNormal;

void main()
{
    //Sample the texture at the interpolated coordinate
    //lowp vec4 col = texture2D( texture, vTexCoord );
    lowp vec4 col = vColor;
    vec4 p = vPosition/scale;
    float l = max(1.,length(p));
    l = 1./l;
    l *= 1.-dot(vNormal,normalize(p))*.4;
    col.xyz *= l;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["MazeLighting"] = getshader
end
    