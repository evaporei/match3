local images = require('images')

local function tileQuads(sheet, tileWidth, tileHeight)
    local sheetWidth = sheet:getWidth() / tileWidth
    local sheetHeight = sheet:getHeight() / tileHeight

    local sprites = {}

    -- each row is split into two halves of 6 variants for the same color
    local loops = {
        { start = 0, finish = sheetWidth / 2 - 1 },
        { start = sheetWidth / 2, finish = sheetWidth - 1 },
    }

    for y = 0, sheetHeight - 1 do
        for _, loop in pairs(loops) do
            local color = {}
            for x = loop.start, loop.finish do
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
    end

    return sprites
end

return {
    tiles = tileQuads(images.tilesheet, 32, 32)
}
