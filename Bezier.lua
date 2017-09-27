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
varying highp vec2 vTexCoord;

uniform float len;
uniform float width;
uniform float blur;
float twidth = width+blur;
uniform vec2 pts[4];

void main()
{
    highp float t = position.y/len;
    highp float tt = 1.0 - t;
    highp vec2 bpos = tt*tt*tt*pts[0] + 3.0*tt*tt*t*pts[1] 
    + 3.0*tt*t*t*pts[2] + t*t*t*pts[3];
    highp vec2 bdir = tt*tt*(pts[1]-pts[0])
         + 2.0*tt*t*(pts[2]-pts[1]) + t*t*(pts[3]-pts[2]);
    bdir = vec2(bdir.y,-bdir.x);
    bdir = twidth*position.x*normalize(bdir);
    bpos = bpos + bdir;
    highp vec4 bzpos = vec4(bpos.x,bpos.y,0,1);
    //Pass the mesh color to the fragment shader
    vTexCoord = vec2(texCoord.x, 1.0 - texCoord.y);
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * bzpos;
}

]],[[
//
// A basic fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform highp float width;
uniform highp float blur;
highp float edge = blur/(width+blur);
uniform lowp vec4 colour;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = colour;
    //if (vTexCoord.x < edge)
    //    col.a = col.a*vTexCoord.x/edge;
    //if (vTexCoord.x > 1. - edge)
    //    col.a = col.a*(1.-vTexCoord.x)/edge;
    //Set the output color to the texture color

    col.a = mix( 0., col.a,
    smoothstep( 0., edge, min(vTexCoord.x,1. - vTexCoord.x) ) );
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Bezier"] = getshader
end
    