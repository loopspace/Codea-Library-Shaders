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
uniform lowp vec2 param;
uniform lowp vec4 colour;
uniform lowp float shade;
uniform mediump float type;
uniform highp vec2 centre;
uniform highp vec2 size;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

highp vec2 julia(highp vec2 z, highp vec2 c)
{
    highp vec2 w;
    w = vec2(z.x*z.x - z.y*z.y,2.*z.x*z.y) + c;
    return w;
}

highp vec2 cantor(highp vec2 z, highp vec2 c)
{
    highp vec2 w;
    w = z*3.;
    mediump float d = mod(floor(w.x) + floor(w.y),2.);
    if (d < .5) {
        w = fract(w);
    } else {
        w = vec2(2.,2.);
    }
    return w;
}

highp vec2 sierpinski(highp vec2 z, highp vec2 c)
{
    highp vec2 w;
    w = z*2.;
    mediump float d = w.x + w.y;
    if (d < 2.) {
        w = fract(w);
    } else {
        w = vec2(2.,2.);
    }
    return w;
}

mediump float radius_test (highp vec2 z)
{
    return 4.*dot(z,z) - 1.;
}

mediump float lone_test (highp vec2 z)
{
    if (z.x > .5) {
        return 1.;
    }
    if (z.x < -.5 ) {
        return 1.;
    }
    if (z.y > .5 ) {
        return 1.;
    }
    if (z.y < -.5 ) {
        return 1.;
    }
    return 0.;
}

void main()
{
    lowp vec4 col;
    highp vec2 z = (vTexCoord - vec2(.5,.5))*size + centre;
    if (type == 1.) {
        z = julia(z,param);
    } else {
         if (type == 2. ) {
            z = cantor(z,param);
        } else {
            if (type == 3. ) {
                z = sierpinski(z,param);
            } else {
                z = z;
            }
        }
    }
    highp vec2 w = (z - centre)/size;
    mediump float r;
    if (type == 1.) {
        r = radius_test(w);
    } else {
        if (type == 2.) {
            r = lone_test(w);
        } else {
            if (type == 3.) {
                r = lone_test(w);
            }
        }
    }
    if (r > 0.) {
        col = colour;
    } else {
        w += vec2(.5,.5);
    //Sample the texture at the interpolated coordinate
        if (run == 1.) {
         col = texture2D( image_a, w );
        } else {
         col = texture2D( image_b, w );
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
    shaders["Recursion"] = getshader
end
    