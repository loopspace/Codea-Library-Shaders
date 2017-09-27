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

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform lowp sampler2D image_a;
uniform lowp sampler2D image_b;
uniform lowp float run;
uniform lowp float radius;
uniform lowp vec4 colour;
uniform lowp float shade;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    lowp vec4 col;
    lowp vec2 z = 2.*(vTexCoord - vec2(.5,.5))*radius;
    lowp float d = dot(z,z);
    lowp vec2 tz;
    if (d != 0.) {
        tz = 2.*z/3. + vec2(z.x*z.x - z.y*z.y, - 2.*z.x*z.y)/(3.*d*d);
    } else {
        tz = z;
    }
    if (abs(tz.x) > radius && abs(tz.y) > radius) {
        col = colour;
    } else {
        tz = tz/(2.*radius) + vec2(.5,.5);
    //Sample the texture at the interpolated coordinate
        if (run == 1.) {
         col = texture2D( image_a, tz );
        } else {
         col = texture2D( image_b, tz );
        }
        col.rgb *= shade;
    }

    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Newton Raphson"] = getshader
end
    