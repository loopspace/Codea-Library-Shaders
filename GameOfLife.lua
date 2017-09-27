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
    //Pass the everything to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    gl_Position = modelViewProjection * position;
}

]],[[
//
// A Game of Life fragment shader, does the hard work.
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

// width and height of the texture for finding neighbours
uniform highp float width;
uniform highp float height;
lowp float colstep = .05;
highp float w = 1./width;
highp float h = 1./height;

// get the neighbours' states
lowp int neighbours (lowp sampler2D s, highp vec2 p)
{
    lowp int alive;
    alive = 0;
    if (texture2D(s,fract(p + vec2(w,0.))).g > .5)
        alive += 1;
    if (texture2D(s,fract(p + vec2(w,h))).g > .5)
        alive += 1;
    if (texture2D(s,fract(p + vec2(0.,h))).g > .5)
        alive += 1;
    if (texture2D(s,fract(p + vec2(-w,h))).g > .5)
        alive += 1;
    if (texture2D(s,fract(p + vec2(-w,0.))).g > .5)
        alive += 1;
    if (texture2D(s,fract(p + vec2(-w,-h))).g > .5)
        alive += 1;
    if (texture2D(s,fract(p + vec2(0.,-h))).g > .5)
        alive += 1;
    if (texture2D(s,fract(p + vec2(w,-h))).g > .5)
        alive += 1;
    return alive;
}

void main()
{
    lowp int count;
    lowp vec4 col;
    count = neighbours(texture,vTexCoord);
    col = texture2D(texture,vTexCoord);

    if (col.r > colstep) {
        col.r -= colstep;
    } else {
        col.r = 0.;
    }
    if (col.g > .5) {
    // alive
        if (count < 2 || count > 3) {
        // lonely or overcrowded, kill it
            col.g = 0.;
            col.r = 1.;
        }
    } else {
    // dead
        if (count == 3) {
        // born
            col.g = 1.;
            col.r = 1.;
            col.b = 1.;
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
    shaders["GameOfLife"] = getshader
end
    