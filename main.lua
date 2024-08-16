love.graphics.setDefaultFilter('nearest', 'nearest')

local push = require('libs.push')
local Timer = require('knife.timer')

local images = require('images')
local sprites = require('sprites')

GAME_WIDTH, GAME_HEIGHT = 512, 288
local offsetX, offsetY = 128, 16

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
                x = (x - 1) * 32,
                y = (y - 1) * 32,
                color = math.random(#sprites.tiles),
                gridX = x,
                gridY = y,
            })
        end
        table.insert(tiles, ts)
    end
    return tiles
end

local tiles = generateTiles()

local selectedTile = tiles[1][1]
local highlightedTile = nil

function love.keypressed(key)
    -- debug
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

    local x, y = selectedTile.gridX, selectedTile.gridY

    if key == 'right' then
        x = x + 1
    end
    if key == 'left' then
        x = x - 1
    end
    if key == 'up' then
        y = y - 1
    end
    if key == 'down' then
        y = y + 1
    end
    -- wrap around screen (for blazingly fast mechanics)
    x = ((x - 1) % 8) + 1
    y = ((y - 1) % 8) + 1

    selectedTile = tiles[y][x]

    if key == 'enter' or key == 'return' then
        if not highlightedTile then
            highlightedTile = { gridX = selectedTile.gridX, gridY = selectedTile.gridY }
        else
            local tile1 = selectedTile
            local tile2 = tiles[highlightedTile.gridY][highlightedTile.gridX]

            local target1 = { x = tile1.x, y = tile1.y }
            local target2 = { x = tile2.x, y = tile2.y }

            local tmp1 = tile1
            tiles[tile1.gridY][tile1.gridX] = tile2
            tiles[tile2.gridY][tile2.gridX] = tmp1

            Timer.tween(0.2, {
                [tile1] = target2,
                [tile2] = target1,
            })

            tile1.gridX, tile1.gridY, tile2.gridX, tile2.gridY = tile2.gridX, tile2.gridY, tile1.gridX, tile1.gridY

            selectedTile = tile2

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
            -- red
            if selectedTile.gridX == tile.gridX and selectedTile.gridY == tile.gridY then
                love.graphics.setColor(1, 0, 0, 234/255)
                love.graphics.setLineWidth(4)
                love.graphics.rectangle(
                    'line',
                    selectedTile.x + offsetX,
                    selectedTile.y + offsetY,
                    32,
                    32,
                    4
                )
                love.graphics.setColor(1, 1, 1, 1)
            end
            -- white, transparent
            if highlightedTile and highlightedTile.gridX == tile.gridX and highlightedTile.gridY == tile.gridY then
                love.graphics.setColor(1, 1, 1, 128/255)
                love.graphics.rectangle(
                    'fill',
                    tile.x + offsetX,
                    tile.y + offsetY,
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

    push:finish()
end
