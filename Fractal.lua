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

//Viewport
uniform highp vec2 size;
uniform highp vec2 centre;
//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = (texCoord - vec2(.5,.5))*size + centre;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
}

]],[[
//
// A basic fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
//uniform lowp sampler2D colours;
uniform mediump float iter;
uniform lowp float type;
uniform highp vec2 param;
uniform lowp vec4 colour;
int it = int(iter);
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

lowp vec4 mandel(highp float x, highp float y, highp float cx, highp float cy, int it)
{
    highp float tx;
    highp float sqrx = x*x;
    highp float sqry = y*y;
    int i = 0;
    lowp vec4 ret;
    while (i < it  && sqrx + sqry < 4.) {
        y = 2.*x*y + cy;
        x = sqrx - sqry + cx;
        sqrx = x*x;
        sqry = y*y;
        i++;
    }
    if (i == it) {
        ret = vec4(0.,0.,0.,1.);
    } else {
        ret = vec4(1.,float(i)/float(it),1.,1.);
    }
    return ret;
}

lowp vec4 mandelbrot(highp float x, highp float y, highp float cx, highp float cy, int it)
{
    return mandel(0.,0.,x,y,it);
}

lowp vec4 julia(highp float x, highp float y, highp float cx, highp float cy, int it)
{
    return mandel(x,y,cx,cy,it);
}

// Newton-Raphson triple root of unity
lowp vec4 newton (highp float x, highp float y, highp float cx, highp float cy, int it)
{
    lowp vec4 ret;
    lowp float tol = .5;
    int i = 0;
    lowp float rt;
    highp float sqx = x*x;
    highp float sqy = y*y;
    highp float d = sqx + sqy;
    highp float tx = x*x*x - 3.*x*y*y - 1.;
    highp float ty = 3.*x*y*y - y*y*y;
    highp float done = tx*tx + ty*ty;
    while (i < it && d != 0. && done > tol)
    {
        tx = 2.*x/3. + (sqx - sqy)/(3. * d * d);
        y = 2.*y/3. - 2.*x*y/(3.*d*d);
        x = tx;
        sqx = x*x;
        sqy = y*y;
        d = sqx + sqy;
        tx = x*(sqx- 3.*sqy) - 1.;
        ty = y*(3.*sqx- sqy);
        done = tx*tx + ty*ty;
        i++;
    }
    if (i == it) {
        ret = vec4(0.,0.,0.,1.);
    } else {
        if (x > 0.) { 
            rt = 0.;
        } else {
            if (y > 0.) { 
                rt = .5;
            } else {
                rt = 1.;
            }
        }
        ret = vec4(rt,float(i)/float(it),1.,1.);
    }
    return ret;
}

// 2D Cantor set
lowp vec4 cantor (highp float x, highp float y, highp float cx, highp float cy, int it)
{
    lowp float d = mod(floor(x) + floor(y),2.);
    lowp int i = 0;
    while (i < it && d < 0.5)
    {
        x *= 3.;
        y *= 3.;
        d = mod(floor(x) + floor(y),2.);
        i++;
    }
    return vec4(1.,float(i)/float(it),1.,1.);
}

// Sierpinski triangle
lowp vec4 sierpinski (highp float x, highp float y, highp float cx, highp float cy, int it)
{
    lowp float d = mod(floor(fract(x) + fract(y)),2.);
    lowp int i = 0;
    while (i < it && d < 0.5)
    {
        x *= 2.;
        y *= 2.;
        d = mod(floor(fract(x) + fract(y)),2.);
        i++;
    }
    return vec4(1.,float(i)/float(it),1.,1.);
}


void main()
{
    highp float x,y,cx,cy;
    lowp vec4 col;
    x = vTexCoord.x;
    y = vTexCoord.y;
    cx = param.x;
    cy = param.y;
    if (type == 1.) { // mandelbrot
        col = mandelbrot(x,y,cx,cy,it);
    } else {
        if (type == 2.) { // julia
            col = julia(x,y,cx,cy,it);
        } else {
            if (type == 3.) { // Newton-Raphson
                col = newton(x,y,cx,cy,it);
            } else {
                if (type == 4.) { // Cantor
                    col = cantor(x,y,cx,cy,it);
                } else {
                    if (type == 5.) { // Sierpinski
                        col = sierpinski(x,y,cx,cy,it);
                    } else {
                        col = mandelbrot(x,y,cx,cy,it);
                    }
                }
            }
        }
    }
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Fractal"] = getshader
end
    