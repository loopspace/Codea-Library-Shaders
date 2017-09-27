local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;
uniform mat4 invModel;
//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec3 normal;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying highp vec3 vNormal;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    highp vec4 n = invModel * vec4(normal,0.);
    vNormal = n.xyz;
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
uniform highp vec3 light;
uniform lowp float ambient;
uniform lowp float useTexture;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;
varying highp vec3 vNormal;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = vColor;//vec4(1.,0.,0.,1.);
    if (useTexture == 1.) {
        col *= texture2D( texture, vTexCoord );
    }

    lowp float c = ambient + (1.-ambient) * max(0.,dot(light, normalize(vNormal)));
    col.xyz *= c;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Lighting"] = getshader
end
    