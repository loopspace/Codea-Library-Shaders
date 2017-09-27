local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;
uniform float time;
uniform vec2 size;
uniform vec2 lr;
uniform float friction;
uniform float factor;
lowp vec4 gravity = vec4(0.,-1.,0.,0.);
//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec4 direction;
attribute vec2 angvel;
attribute vec2 origin;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;


void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = vec2(1.-texCoord.y,1.-texCoord.x);
    lowp vec4 pos;
    lowp float angle = time*angvel.x;
    highp vec4 A = gravity/(friction*friction) - direction/friction;
    highp vec4 B = vec4(origin,0.,0.) - A;
    lowp mat2 rot = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));

    pos = (position - vec4(origin,0.,0.));
    pos.xy = rot * pos.xy;
    pos += exp(-factor*time*friction)*A + B + factor*time * gravity/friction;
    //pos = pos + vec4(origin,0.,0.) + 60.*time * direction + 30. * time * time * gravity;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * pos;
}

]],[[
//
// A basic fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = texture2D( texture, vTexCoord );

    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Explosion"] = getshader
end
    