love.graphics.setDefaultFilter('nearest', 'nearest')

local push = require('libs.push')

local images = require('images')
local sprites = require('sprites')

GAME_WIDTH, GAME_HEIGHT = 512, 288

function love.load()
    love.window.setTitle('match3')

    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, 1280, 720, {
        vsync = true,
        fullscreen = false,
        resizable = true,
    })
end

local function generateTiles()
    local tiles = {}
    for _ = 1, 8 do
        local ts = {}
        for _ = 1, 8 do
            table.insert(ts, math.random(#sprites.tiles))
        end
        table.insert(tiles, ts)
    end
    return tiles
end

local tiles = generateTiles()

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

local function drawTiles()
    local offsetX, offsetY = 128, 16

    for y = 1, 8 do
        for x = 1, 8 do
            love.graphics.draw(
                images.tilesheet,
                sprites.tiles[tiles[y][x]],
                (x - 1) * 32 + offsetX,
                (y - 1) * 32 + offsetY
            )
        end
    end
end

function love.draw()
    push:start()

    drawTiles()

    push:finish()
end
