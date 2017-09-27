local getshader = function()
    return shader([[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;

uniform vec3 centre;
uniform float time;
uniform vec3 angularVelocity;
mediump vec3 axis = normalize(angularVelocity);
mediump float speed = length(angularVelocity);
mediump vec4 rot = vec4(cos(time*speed/2.),sin(time*speed/2.)*axis);

//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

mediump vec4 qmult (mediump vec4 p, mediump vec4 q)
{
    mediump float a = p.x * q.x - p.y * q.y - p.z * q.z - p.w * q.w;
    mediump float b = p.x * q.y + p.y * q.x + p.z * q.w - p.w * q.z;
    mediump float c = p.x * q.z - p.y * q.w + p.z * q.x + p.w * q.y;
    mediump float d = p.x * q.w + p.y * q.z - p.z * q.y + p.w * q.x;
    return vec4(a,b,c,d);
}

mediump vec4 qconj (mediump vec4 q)
{
    return vec4(q.x,-q.y,-q.z,-q.w);
}

mediump vec3 qvmult(mediump vec4 q, mediump vec3 v)
{
    mediump vec4 p = vec4(0,v);
    mediump vec4 pq = qmult(q,qmult(p,qconj(q)));
    return vec3(pq.yzw);
}


void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = vec2(texCoord.x, 1.0 - texCoord.y);
    mediump vec3 pos = position.xyz/position.w - centre;
    pos = qvmult(rot,pos);
    pos += centre;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * vec4(pos,1);
}

]],[[
//
// A basic fragment shader
//

//Default precision qualifier
precision highp float;

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
    col*=vColor;
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Rotation"] = getshader
end
    