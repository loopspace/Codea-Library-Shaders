-- Library Shaders

shaderNames = {}
shaders = {}

-- Use this function to perform your initial setup
function setup()
    for k,v in ipairs(shaderNames) do
        saveShader(v)
        print(v .. " saved")
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end

function saveShader(s)
    local sh = shader("Documents:" .. s)
    local shtab = [[
local getshader = function()
    return shader(]]
    .. "[[\n" .. sh.vertexProgram .. "\n]],[[\n" .. sh.fragmentProgram .. "\n]])\n" ..
    [[
end
    
if _M then
    return getshader()
else
    shaders["]]
     .. s .. 
    [["] = getshader
end
    ]]
    saveProjectTab(s,shtab)
end

--[[
                                                          shader()
]]
shaderNames = {
    "Advect",
    "Affine",
    "Alpha Mask",
    "Alpha Smooth",
    "Alternate Images",
    "Benchmark",
    "Bezier",
    "Border",
    "Boundary",
    "Brunnian",
    "Cellular",
    "Colour Manipulation",
    "Colour Mapping",
    "Cubic",
    "Cyclic Rendering",
    "Default",
    "Descending",
    "Divergence",
    "Droste",
    "Explosion",
    "Flag",
    "Flood Fill Render",
    "Flood Fill",
    "Force",
    "Fractal Popup",
    "Fractal",
    "GameOfLife",
    "Gradient Fill",
    "Gradient",
    "Grey Scale",
    "Grid",
    "Height Map",
    "Helix",
    "Jacobi",
    "Julia Set",
    "Lighting",
    "MatrixArray",
    "MazeLighting",
    "Meta Ball",
    "Newton Raphson",
    "No Texture",
    "Particle Position",
    "Particle Velocity",
    "Path Mask",
    "Poincaré disk",
    "PotentialFlow",
    "Random",
    "Recursion",
    "Rotation",
    "ShaderTest",
    "Shadow",
    "SphereShader",
    "Split Textures",
    "Stereogram",
--[[
                                                          shader()
]]
    "Stored Shader",
    "Stretch",
    "Texture Affine Transformations",
    "Texture Rotation",
    "Threshold",
    "Tiled Texture",
    "Tiling",
    "Voronoi Growth",
    "Voronoi",
    "Wireframe",
    "curvature"
}