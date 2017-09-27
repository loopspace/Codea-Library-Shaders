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
uniform lowp sampler2D textureA;
uniform lowp sampler2D textureB;
uniform lowp sampler2D textureC;
uniform lowp sampler2D textureD;
uniform lowp sampler2D textureE;
uniform lowp sampler2D textureF;
uniform lowp sampler2D textureG;
uniform lowp sampler2D textureH;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

lowp vec4 mixit(vec4 a, vec4 b, vec4 c, vec4 d, vec4 e, vec4 f, vec4 g, vec4 h)
{
    lowp vec4 rt = f;
    rt = mix(rt,d,d.a);
    rt = mix(rt,b,b.a);
    rt = mix(rt,a,a.a);
    rt = mix(rt,c,c.a);
    rt = mix(rt,e,e.a);
    rt = mix(rt,g,g.a);
    return rt;
}

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 colA = texture2D( textureA, vTexCoord ) * vColor;
    lowp vec4 colB = texture2D( textureB, vTexCoord ) * vColor;
    lowp vec4 colC = texture2D( textureC, vTexCoord ) * vColor;
    lowp vec4 colD = texture2D( textureD, vTexCoord ) * vColor;
    lowp vec4 colE = texture2D( textureE, vTexCoord ) * vColor;
    lowp vec4 colF = texture2D( textureF, vTexCoord ) * vColor;
    lowp vec4 colG = texture2D( textureG, vTexCoord ) * vColor;
    lowp vec4 colH = texture2D( textureH, vTexCoord ) * vColor;
    lowp vec4 col;
    if (colA.a > 0.) {
        col = mixit(colA,colB,colC,colD,colE,colF,colG,colH);
    } else if (colB.a > 0.) {
        col = mixit(colB,colC,colD,colE,colF,colG,colH,colA);
    } else if (colC.a > 0.) {
        col = mixit(colC,colD,colE,colF,colG,colH,colA,colB);
    } else if (colD.a > 0.) {
        col = mixit(colD,colE,colF,colG,colH,colA,colB,colC);
    } else if (colE.a > 0.) {
        col = mixit(colE,colF,colG,colH,colA,colB,colC,colD);
    } else if (colF.a > 0.) {
        col = mixit(colF,colG,colH,colA,colB,colC,colD,colE);
    } else if (colG.a > 0.) {
        col = mixit(colG,colH,colA,colB,colC,colD,colE,colF);
    } else if (colH.a > 0.) {
        col = mixit(colH,colA,colB,colC,colD,colE,colF,colG);
    } else {
        col = colA;
    }
    
    
    //Set the output color to the texture color
    gl_FragColor = col;
}

]])
end
    
if _M then
    return getshader()
else
    shaders["Brunnian"] = getshader
end
    