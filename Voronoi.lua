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
uniform lowp vec2 pts[16];

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    lowp float d = 2.;
    lowp float dd;
    lowp float p = 0.;
    lowp int i;
    lowp float s;
    for (i = 0; i < 16; i++) {
        dd = distance(vTexCoord,pts[i]);
        s = step(d,dd);
        p = (1.-s)*(float (i)) + s*p;
        d = s*d + (1.-s)*dd;
    }
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = texture2D( texture, vec2(.5,p/16.) );

    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Voronoi"] = getshader
end
    