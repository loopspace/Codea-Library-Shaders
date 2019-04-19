local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;
uniform vec3 light;
uniform float orientation;
//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec3 normal;
//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying lowp float vShade;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    if (orientation == 1.) {
        vTexCoord = vec2(1.-texCoord.x,1.-texCoord.y);
    } else {
    if (orientation == 2.) {
        vTexCoord = vec2(texCoord.y,1.-texCoord.x);
    } else {
    if (orientation == 3.) {
        vTexCoord = vec2(1.-texCoord.y,texCoord.x);
    } else {
        vTexCoord = vec2(texCoord.x,texCoord.y);
    }
    }
    }
    
    if (light != vec3(0.,0.,0.)) {
        lowp vec4 nor = modelViewProjection * vec4(normal,0);
        vShade = (dot(nor.xyz,light) + 2.)/3.;
    } else {
        vShade = 1.;
    }
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
}

]],[[
//
// A basic fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform lowp sampler2D image;
uniform lowp vec4 colour;
uniform lowp vec4 alive;
uniform lowp float revealTexture;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;
varying lowp float vShade;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col;
    col = texture2D( texture, vTexCoord );

    if (col.g == 1.) {
        // alive, fade from yellow to blue
        col.b = 0.;
        col = col.r*col + (1.-col.r)*alive;
    } else {
        // dead
        if (col.r > 0.) {
            // but recently so
            col.g = 0.;
            col.b = 0.;
            lowp vec4 fcol;
            if (revealTexture == 1.) {
                fcol = texture2D( image, vTexCoord );
            } else {
                fcol = colour;
            }
            col.rgb = col.rgb + (1. - col.r)*fcol.rgb;
        } else {
            if (revealTexture == 1. && col.b == 1.) {
                col = texture2D( image, vTexCoord );
            } else {
                col.rgb = colour.rgb;
            }
        }
    }

    col.rgb *= vShade;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader
else
    shaders["Alternate Images"] = getshader
end
    