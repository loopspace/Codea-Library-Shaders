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
    //store_bin = 1.;
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
uniform lowp float width;
uniform lowp float height;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;
lowp float colstep = .05;

lowp float rfract (in lowp float d)
{
    lowp float q;
    if (d == 1.) {
        q = d;
    } else {
        q = fract(d);
    }
    return q;
}

lowp vec2 vrfract(in lowp vec2 v)
{
    lowp vec2 u;
    u.x = rfract(v.x);
    u.y = rfract(v.y);
    return u;
}


lowp int neighbours (in sampler2D source, in lowp vec2 pos)
{
    lowp int alive;
    alive = 0;
    lowp vec2 Offset[8];
    Offset[0] = 
        vec2(1./width,0.);
    Offset[1] = 
    vec2(1./width,1./height);
    Offset[2] = 
    vec2(0.,1./height);
    Offset[3] = 
    vec2(-1./width,1./height);
    Offset[4] = 
    vec2(-1./width,0.);
    Offset[5] = 
    vec2(-1./width,-1./height);
    Offset[6] = 
    vec2(0.,-1./height);
    Offset[7] = 
    vec2(1./width,-1./height);
    if (texture2D(source,vrfract(pos + Offset[0])).g > .5)
        alive += 1;
    if (texture2D(source,vrfract(pos + Offset[1])).g > .5)
        alive += 1;
    if (texture2D(source,vrfract(pos + Offset[2])).g > .5)
        alive += 1;
    if (texture2D(source,vrfract(pos + Offset[3])).g > .5)
        alive += 1;
    if (texture2D(source,vrfract(pos + Offset[4])).g > .5)
        alive += 1;
    if (texture2D(source,vrfract(pos + Offset[5])).g > .5)
        alive += 1;
    if (texture2D(source,vrfract(pos + Offset[6])).g > .5)
        alive += 1;
    if (texture2D(source,vrfract(pos + Offset[7])).g > .5)
        alive += 1;
    return alive;
}

void main()
{
    lowp int count;
    lowp vec4 col;
    //Sample the texture at the interpolated coordinate
    if (run == 1.) {
        count = neighbours(image_a,vTexCoord);
        col = texture2D(image_a,vTexCoord);
    } else {
        count = neighbours(image_b,vTexCoord);
        col = texture2D(image_b,vTexCoord);
    }

    if (col.r > colstep) {
        col.r += -colstep;
    } else {
        col.r = 0.;
    }
    if (col.g > .5) {
        if (count < 2 || count > 3) {
            col.g = 0.;
        }
    } else {
        if (count == 3) {
            col.g = 1.;
            col.r = 1.;
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
    shaders["Stored Shader"] = getshader
end
    