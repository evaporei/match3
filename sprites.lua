local images = require('images')

local function tileQuads(sheet, tileWidth, tileHeight)
    local sheetWidth = sheet:getWidth() / tileWidth
    local sheetHeight = sheet:getHeight() / tileHeight

    local sprites = {}

    for y = 0, sheetHeight - 1 do
        local color = {}
        for x = 0, sheetWidth / 2 - 1 do
            local sprite = love.graphics.newQuad(
                x * tileWidth,
                y * tileHeight,
                tileWidth,
                tileHeight,
                sheet:getDimensions()
            )
            table.insert(color, sprite)
        end
        table.insert(sprites, color)
        color = {}
        for x = 6, sheetWidth - 1 do
            local sprite = love.graphics.newQuad(
                x * tileWidth,
                y * tileHeight,
                tileWidth,
                tileHeight,
                sheet:getDimensions()
            )
            table.insert(color, sprite)
        end
        table.insert(sprites, color)
    end

    return sprites
end

return {
    tiles = tileQuads(images.tilesheet, 32, 32)
}
