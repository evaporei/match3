love.graphics.setDefaultFilter('nearest', 'nearest')

local push = require('libs.push')

local images = require('images')
local sprites = require('sprites')

GAME_WIDTH, GAME_HEIGHT = 512, 288

local offsetX, offsetY = 128, 16
local selectedTile = { y = 1, x = 1 }
local highlightedTile = nil

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
    for y = 1, 8 do
        local ts = {}
        for x = 1, 8 do
            table.insert(ts, {
                y = (y - 1) * 32,
                x = (x - 1) * 32,
                color = math.random(#sprites.tiles),
            })
        end
        table.insert(tiles, ts)
    end
    return tiles
end

local tiles = generateTiles()

function love.keypressed(key)
    if key == 'right' then
        selectedTile.x = selectedTile.x + 1
    end
    if key == 'left' then
        selectedTile.x = selectedTile.x - 1
    end
    if key == 'up' then
        selectedTile.y = selectedTile.y - 1
    end
    if key == 'down' then
        selectedTile.y = selectedTile.y + 1
    end
    selectedTile.x = ((selectedTile.x - 1) % 8) + 1
    selectedTile.y = ((selectedTile.y - 1) % 8) + 1

    if key == 'enter' or key == 'return' then
        if not highlightedTile then
            -- need to copy
            highlightedTile = { x = selectedTile.x, y = selectedTile.y }
        else
            local tmp = tiles[selectedTile.y][selectedTile.x].color
            tiles[selectedTile.y][selectedTile.x].color = tiles[highlightedTile.y][highlightedTile.x].color
            tiles[highlightedTile.y][highlightedTile.x].color = tmp
            highlightedTile = nil
        end
    end

    if key == 'escape' then
        love.event.quit()
    end
end

local function drawTiles()
    for y = 1, 8 do
        for x = 1, 8 do
            local tile = tiles[y][x]
            love.graphics.draw(
                images.tilesheet,
                sprites.tiles[tile.color],
                tile.x + offsetX,
                tile.y + offsetY
            )
        end
    end
end

local function drawSelected()
    love.graphics.setColor(1, 0, 0, 234/255)
    love.graphics.setLineWidth(4)
    local x, y = selectedTile.x, selectedTile.y
    love.graphics.rectangle(
        'line',
        tiles[y][x].x + offsetX,
        tiles[y][x].y + offsetY,
        32,
        32,
        4
    )
end

local function drawHighlighted()
    if highlightedTile then
        love.graphics.setColor(1, 1, 1, 128/255)
        local x, y = highlightedTile.x, highlightedTile.y
        love.graphics.rectangle(
            'fill',
            tiles[y][x].x + offsetX,
            tiles[y][x].y + offsetY,
            32,
            32,
            4
        )
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function love.draw()
    push:start()

    drawTiles()

    drawSelected()

    drawHighlighted()

    push:finish()
end
