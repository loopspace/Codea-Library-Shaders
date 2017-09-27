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

//Default precision qualifier
precision highp float;

//This represents the current texture on the mesh
uniform sampler2D velocity;
uniform vec2 point;
uniform vec2 force;
uniform float radius;
uniform float deltaTime;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

void main()
{
    // Current velocity
    lowp vec4 col = texture2D(velocity,vTexCoord);
    // Compute force component
    float l = dot(vTexCoord - point,vTexCoord - point);
    l = exp(-l/radius);
    col.xy += force * deltaTime * l;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Force"] = getshader
end
    