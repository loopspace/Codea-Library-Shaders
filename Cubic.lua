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

uniform float pts_1;
uniform float pts_2;
uniform float pts_3;
uniform float pts_4;
uniform float len;

void main()
{
    highp float t = position.y/len;
    highp float y = pts_1 + t*pts_2 + t*t*pts_3 + t*t*t*pts_4;
    highp float dy = pts_2 + 2.0*t*pts_3 + 3.*t*t*pts_4;
    highp vec2 bdir = vec2(dy,-1.);
    bdir = position.x*normalize(bdir)/len;
    highp vec2 bpos = vec2(t,y) + bdir;
    highp vec4 bzpos = vec4(bpos.x,bpos.y,0,1);
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * bzpos;
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
    lowp vec4 col = vColor;
    if (vTexCoord.x < .2)
        col.a = col.a*vTexCoord.x/.2;
    if (vTexCoord.x > .8)
        col.a = col.a*(1.-vTexCoord.x)/.2;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Cubic"] = getshader
end
    