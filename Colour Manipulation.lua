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
    vTexCoord = vec2(texCoord.x, texCoord.y);
    
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
}

]],[[
//
// A basic fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform lowp vec4 red;
uniform lowp vec4 green;
uniform lowp vec4 blue;
uniform lowp vec4 alpha;
uniform lowp vec4 redcurve;
uniform lowp vec4 greencurve;
uniform lowp vec4 bluecurve;
uniform lowp vec4 alphacurve;
uniform lowp vec4 brightness;

mediump vec4 csat = red + green + blue + alpha;
mediump float cnorm = max(max(max(1.,csat.r),csat.g),csat.b);

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

lowp float cubic(lowp vec4 c, lowp float t)
{
    return c.x + c.y * t + c.z * t * t + c.w * t * t * t;
}

void main()
{
    //Sample the texture at the interpolated coordinate
    mediump vec4 col = texture2D( texture, vTexCoord );
    col *= vColor;
    col.r = cubic(redcurve, col.r);
    col.g = cubic(greencurve, col.g);
    col.b = cubic(bluecurve, col.b);
    col.a = cubic(alphacurve, col.a);
    col.r = cubic(brightness, col.r);
    col.g = cubic(brightness, col.g);
    col.b = cubic(brightness, col.b);
    col = col.r * red + col.g * green + col.b * blue + col.a * alpha;
    col.rgb = col.rgb/cnorm;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Colour Manipulation"] = getshader
end
    