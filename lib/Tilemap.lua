local Class = require("hump.class")
local TileType = require("lib.TileType")
local Tilemap = Class{}

local function clone(t)
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

function Tilemap:init(sizeX, sizeY)
    -- initialize tiles with a name and sprite index from Quads table
    self.grassTile = TileType("grass", 1)
    self.swampTile = TileType("swamp", 2)
    self.waterTile = TileType("water", 3, false)

    -- create the tile array and set all to grass
    self.tiles = {}
    self.sizeX = sizeX
    self.sizeY = sizeY
    for x = 1, sizeX do
        for y = 1, sizeY do
            self.tiles[x * sizeY + y-1] = self.grassTile
        end
    end

    -- swamp
    for x = 3, 5 do
        for y = 7, 10 do
            self.tiles[x * sizeY + y-1] = self.swampTile
        end
    end

    -- U shaped water
    self.tiles[4 * sizeY + 4-1] = self.waterTile
    self.tiles[5 * sizeY + 4-1] = self.waterTile
    self.tiles[6 * sizeY + 4-1] = self.waterTile
    self.tiles[7 * sizeY + 4-1] = self.waterTile
    self.tiles[8 * sizeY + 4-1] = self.waterTile
    self.tiles[4 * sizeY + 5-1] = self.waterTile
    self.tiles[4 * sizeY + 6-1] = self.waterTile
    self.tiles[8 * sizeY + 5-1] = self.waterTile
    self.tiles[8 * sizeY + 6-1] = self.waterTile

end

-- set tile at x, y to given type
function Tilemap:setTile(x, y, type)
    -- TODO: check if tiles[x * sizeY + y-1] exists
    self.tiles[x * sizeY + y-1] = type
end

-- return the tile at given WORLD coordinates
function Tilemap:getTile(mx, my)
    local tx = math.ceil(mx / 32)
    local ty = math.ceil(my / 32)
    -- self.tiles[tx][ty]
    if tx >= 1 and tx <= self.sizeX and ty >= 1 and ty <= self.sizeY then
        return tx, ty
    else
        print("No tile clicked")
        return 0, 0
    end
end

-- return walkable value of tile at given TILEMAP coordinates
function Tilemap:isTileWalkable(tx, ty)
    if tx >= 1 and tx <= self.sizeX and ty >= 1 and ty <= self.sizeY then
        return self.tiles[tx * self.sizeY + ty-1].walkable
    end
end

function Tilemap:getTileGrid()
    local copy = clone(self.tiles)
    return copy
end



function Tilemap:draw()
    for x = 1, self.sizeX do
        for y = 1, self.sizeY do
            love.graphics.draw(Tileset, self.tiles[x * self.sizeY + y-1].sprite, x * 32 - 32, y * 32 - 32)
        end
    end
end

return Tilemap