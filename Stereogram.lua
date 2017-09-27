local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;
uniform mat4 LeftEyeMatrix;
uniform float panels;
mediump float ratio = panels/(panels - 1.);
//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying highp vec2 vEyeCoord;
varying highp vec2 vBaseCoord;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = vec2(texCoord.x,1.-texCoord.y);
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
    highp vec4 leftPosition = LeftEyeMatrix * position;
    vEyeCoord.x = (leftPosition.x/(2.*leftPosition.w) + .5)*ratio;
    vEyeCoord.y = leftPosition.y/(2.*leftPosition.w) + .5;
    highp vec4 rpos = position;
    rpos.z = 0.;
    highp vec4 basePosition = modelViewProjection * rpos;
    vBaseCoord.x = (basePosition.x/(2.*basePosition.w) + .5)*ratio;
    vBaseCoord.y = basePosition.y/(2.*basePosition.w) + .5;
}

]],[[
//
// A basic fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform lowp sampler2D lefteye;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;
varying highp vec2 vEyeCoord;
varying highp vec2 vBaseCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 texc = texture2D( texture, vTexCoord );
    lowp vec4 col;
    if (texc.a > .5 && vColor.a > .5) {
        col = texture2D( lefteye, vEyeCoord );
    } else {
        col = texture2D( lefteye, vBaseCoord );
    }
    //col.rgb *= vColor.rgb;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Stereogram"] = getshader
end
    