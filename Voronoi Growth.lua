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
uniform highp float size;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    mediump vec4 col = vec4(0,0,0,0);
    mediump int n = 0;
    mediump vec4 colt;
    for (int i = 0; i <3; i++) {
        for (int j = 0; j <3; j++) {
            colt = texture2D(texture,vTexCoord + vec2((float(i) - 1.)/size, (float(j)-.1)/size ));
            n += int(colt.a);
            col += colt;
        }
    }
    // n = max(n,1);
    colt = texture2D(texture,vTexCoord);
    mediump vec4 c = colt + (1. - colt.a)*col/float(n);
    //Set the output color to the texture color
    gl_FragColor = c;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Voronoi Growth"] = getshader
end
    