love.graphics.setDefaultFilter('nearest', 'nearest')

local push = require('libs.push')
local Timer = require('knife.timer')

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
                -- drawing
                y = (y - 1) * 32,
                x = (x - 1) * 32,
                color = math.random(#sprites.tiles),
                -- fixed
                gridX = x,
                gridY = y,
            })
        end
        table.insert(tiles, ts)
    end
    return tiles
end

local tiles = generateTiles()

function love.keypressed(key)
    if key == 'p' then
        print('selectedTile { x = ' .. tostring(selectedTile.x) .. ', y = ' .. tostring(selectedTile.y) .. ' },')
        local s = '['
        for y = 1, 8 do
            s = s .. '\n['
            for x = 1, 8 do
                local tile = tiles[y][x]
                local tileStr = '{ x = ' .. tostring(tile.x) .. ', y = ' .. tostring(tile.y) .. ', gridX = ' .. tostring(tile.gridX) .. ', gridY = ' .. tostring(tile.gridY) .. ' },'
                s = s .. tileStr
            end
        end
        s = s .. ']'
        print(s)
    end
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
    -- wrap around screen (for blazingly fast mechanics)
    selectedTile.x = ((selectedTile.x - 1) % 8) + 1
    selectedTile.y = ((selectedTile.y - 1) % 8) + 1

    if key == 'enter' or key == 'return' then
        if not highlightedTile then
            -- need to copy
            highlightedTile = { x = selectedTile.x, y = selectedTile.y }
        else
            local tile1 = {}
            local tile2 = {}
            -- ewww maybe the teacher was right in storing the tiles directly
            -- instead of their x and y...
            for y = 1, 8 do
                for x = 1, 8 do
                    local tile = tiles[y][x]
                    if tile.gridX == selectedTile.x and tile.gridY == selectedTile.y then
                        tile1 = tile
                    end
                    if tile.gridX == highlightedTile.x and tile.gridY == highlightedTile.y then
                        tile2 = tile
                    end
                end
            end
            local tmp1 = { x = tile1.x, y = tile1.y }
            local tmp2 = { x = tile2.x, y = tile2.y }

            Timer.tween(0.2, {
                [tile1] = tmp2,
                [tile2] = tmp1,
            }):finish(function()
                tile1.gridX, tile1.gridY, tile2.gridX, tile2.gridY = tile2.gridX, tile2.gridY, tile1.gridX, tile1.gridY
            end)

            selectedTile = highlightedTile

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
            -- tile itself
            love.graphics.draw(
                images.tilesheet,
                sprites.tiles[tile.color],
                tile.x + offsetX,
                tile.y + offsetY
            )
        end
    end
end

local function drawModifiers()
    for y = 1, 8 do
        for x = 1, 8 do
            local tile = tiles[y][x]
            -- red
            if selectedTile.x == tile.gridX and selectedTile.y == tile.gridY then
                love.graphics.setColor(1, 0, 0, 234/255)
                love.graphics.setLineWidth(4)
                love.graphics.rectangle(
                    'line',
                    (selectedTile.x - 1) * 32 + offsetX,
                    (selectedTile.y - 1) * 32 + offsetY,
                    32,
                    32,
                    4
                )
                love.graphics.setColor(1, 1, 1, 1)
            end
            -- white, transparent
            if highlightedTile and highlightedTile.x == tile.gridX and highlightedTile.y == tile.gridY then
                love.graphics.setColor(1, 1, 1, 128/255)
                love.graphics.rectangle(
                    'fill',
                    (highlightedTile.x - 1) * 32 + offsetX,
                    (highlightedTile.y - 1) * 32 + offsetY,
                    32,
                    32,
                    4
                )
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    push:start()

    drawTiles()

    drawModifiers()

    push:finish()
end
