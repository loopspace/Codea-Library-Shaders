local getshader = function()
    return shader([[
//
// Vertex shader
//
uniform mat4 modelViewProjection;
attribute vec4 position;
varying highp vec4 vPos;
 
void main()
{  
    gl_Position = modelViewProjection * position;
    vPos = position;
}
]],[[
//
// Grid: Fragment shader
// Version 2012.11.23.00.30
//
precision highp float;
varying vec4 vPos;
    const float p = 50.0; // Periodicity of grid
    const float w = 10.0; // Width of grid lines
    const float fade = 0.2 * w; // Anti-aliasing zone width
    const float threshold = 0.05; // Threshold for discard
    const float wMin = fade;
    const float wMax = w - fade;
void main()
{ 
    vec3 d = mod(vPos.xyz, p);
     
    // Set the red channel:
    // if (d.x < w)
    //     r = 1.0;
    // else
    //     r = 0.0;
    float r = d.x < w ? 1.0 : 0.0;
    float g = d.y < w ? 1.0 : 0.0;
    float b = d.z < w ? 1.0 : 0.0;
 
    // Set the alpha for the red channel:
    // if (d.x < wMin)
    //     ar = d.x / fade;
    // elseif (d.x < wMax)
    //     ar = 1.0;
    // elseif (d.x < w)
    //     ar = 1.0 - (d.x - wMax) / fade;
    // else
    //     ar = 0.0;
    float ar = d.x < wMin ? d.x / fade :
        (d.x < wMax ? 1.0 :
        (d.x < w ? 1.0 - (d.x - wMax) / fade : 0.0));
    float ag = d.y < wMin ? d.y / fade :
        (d.y < wMax ? 1.0 :
        (d.y < w ? 1.0 - (d.y - wMax) / fade : 0.0));
    float ab = d.z < wMin ? d.z / fade :
        (d.z < wMax ? 1.0 :
        (d.z < w ? 1.0 - (d.z - wMax) / fade : 0.0));
     
    float a = 1.0 - (1.0 - ar) * (1.0 - ag) * (1.0 - ab);
    if (a < threshold) {discard;} else {
    //Set the output color to the texture color
    gl_FragColor = vec4(r * ar, g * ag, b * ab, a);
    }
}
]])
end
    
if _M then
    return getshader()
else
    shaders["Grid"] = getshader
end
    