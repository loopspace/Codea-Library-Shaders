local getshader = function()
    return shader([[
//
// A metaballs shader
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
    vColor    = color;
    vTexCoord = texCoord;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
    
}
]],[[

//
// A metaballs fragment shader
//
precision highp float;
//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform float width;
uniform float height;
uniform float schwelle;
uniform vec2 balls[40];
uniform float time;
highp vec2 size = vec2(width,height);
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;


//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

float metaball(vec2 center, vec2 point) {
    vec2 v = size*point-center;
    float l = dot(v,v);
    if (l < .05) return 2.;
    return .1/l;
}

lowp vec4 effect(
  highp vec2 coord
) {
        float val = 0.0;
        for (int i =0; i<40; i++) {
            val = val + metaball(balls[i],coord);
        }

    vec4 bar;
        
    if (val < schwelle) {
            val = val / schwelle;
            bar = vec4(
                0.8*(1.0-coord.x),
                0.8*(1.0-coord.y),
                0.3*val,
                1.0
            );
        }
        else {
            bar = vec4(
                0.8*coord.x,
                0.8*coord.y,
                0.0,1.0
            );
        }
        //float foo = mod(time,1.0);
        //if (foo < 0.1) {
         //return bar + vec4(vec3(foo*3.14*50.0), 1.0);
        //}   
    return bar;
}

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = texture2D( texture, vTexCoord );
    //Pass the balls effect color to the fragment
    lowp vec4 bColor    = effect(vTexCoord);
    //Set the output color to the texture color
    gl_FragColor = bColor*col;
    
}
]])
end
    
if _M then
    return getshader()
else
    shaders["Meta Ball"] = getshader
end
    