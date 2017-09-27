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

//This is an output variable that will be passed to the fragment shader
varying highp vec3 vPosition;
void main()
{
    //Pass the mesh color to the fragment shader

    vPosition = position.xyz;
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
uniform lowp sampler2D texture;
uniform vec3 vertices[4];
uniform vec4 colours[4];

vec3 np = cross(vertices[0]-vertices[1],vertices[0]-vertices[2]);
vec3 nx = cross(np,vertices[0] - vertices[2]);
vec3 ny = cross(np,vertices[0] - vertices[1]);
vec3 ox = (dot(nx,vertices[0]-vertices[3])*vertices[1] - dot(nx,vertices[0]-vertices[1])*vertices[3]);
float dx = dot(nx,vertices[1] - vertices[3]);
vec3 oy = (dot(ny,vertices[0]-vertices[3])*vertices[2] - dot(ny,vertices[0]-vertices[2])*vertices[3]);
float dy = dot(ny,vertices[2] - vertices[3]);
vec3 vx = (vertices[1] - vertices[0])/dot(vertices[1] - vertices[0],vertices[1] - vertices[0]);
vec3 vy = (vertices[2] - vertices[0])/dot(vertices[2] - vertices[0],vertices[2] - vertices[0]);

varying highp vec3 vPosition;
void main()
{
    vec3 qx;
    vec3 qy;
    float x;
    float y;
    if (dx != 0.) {
        qx = (dot(ny,dx*vertices[0] - ox)*vPosition - dot(ny, vertices[0] - vPosition) * ox)/(dot(ny,dx*vPosition - ox));

    } else {
        qx = vPosition + dot(ny,vertices[0] - vPosition)*(vertices[2] - vertices[0])/dot(ny,vertices[2] - vertices[0]);
    }
    x = dot(qx - vertices[0],vx);
    if (dy != 0.) {
        qy = (dot(nx,dy*vertices[0] - oy)*vPosition - dot(nx, vertices[0] - vPosition) * oy)/(dot(nx,dy*vPosition - oy));
    } else {
        qy = vPosition + dot(nx,vertices[0] - vPosition)*(vertices[1] - vertices[0])/dot(nx,vertices[1] - vertices[0]);
    }
    y = dot(qy - vertices[0],vy);
    lowp vec4 tex = texture2D( texture, vec2(x,y) );
    lowp vec4 col = (1.-y)*(1.-x)*colours[0] + (1.-y)*x*colours[1] + y*(1.-x)*colours[2] + y*x*colours[3];
    //Set the output color to the texture color
    gl_FragColor = col*tex;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Gradient Fill"] = getshader
end
    