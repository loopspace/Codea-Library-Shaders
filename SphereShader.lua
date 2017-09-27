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
precision highp float;
 
uniform lowp sampler2D texture;
uniform float time;
uniform float fraction;
uniform float height;
highp float h = height*height;
highp float rh = h/(h-1.);
highp float sqrh = sqrt(rh);
 
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec4 vPosition;

void main()
{
  //vec2 tc = vTexCoord.xy;
  vec2 p = (-1.0 + 2.0 * vTexCoord)/sqrh;
  float r = dot(p,p);
  if (r > 1.) discard; 
  float t = (h + sqrt(r - r*h + h))/(r+h);
    float phi = 1.-acos(t*p.y)/3.1415;
    float theta = mod(atan(
        (1.-t)*height,
        t*p.x)/(2.*3.1415)+time,1.);
  //vec2 uv = mod((fraction + time)*vec2(1.,1.) + p*f,vec2(1.,1.));
  vec4 c = texture2D( texture, vec2(theta,phi));
  gl_FragColor = vec4(c.xyz, 1.0);
}
 
]])
end
    
if _M then
    return getshader()
else
    shaders["SphereShader"] = getshader
end
    