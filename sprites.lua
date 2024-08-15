local images = require('images')

local function quads(sheet, tileWidth, tileHeight)
    local sheetWidth = sheet:getWidth() / tileWidth
    local sheetHeight = sheet:getHeight() / tileHeight

    local sprites = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            local sprite = love.graphics.newQuad(
                x * tileWidth,
                y * tileHeight,
                tileWidth,
                tileHeight,
                sheet:getDimensions()
            )
            table.insert(sprites, sprite)
        end
    end

    return sprites
end

return {
    tiles = quads(images.tilesheet, 32, 32)
}
