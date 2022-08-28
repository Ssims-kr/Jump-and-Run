--[[ Included ]]--
local class = require("Script.Library.middleclass")



--[[ Class ]]--
local ResourceManager = class("ResourceManager")



--[[ Member Variables ]]--
local BackgroundResource = nil
local TileResource = {}
local CharacterResource = {
    Blue = nil,
    Green = nil,
    Red = nil,
    Yellow = nil,
}
local HudResource = {
    Number = {
        {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
    },
    Heart = {
        Full = nil,
        Empty = nil,
    },
}
local ObjectResource = {
    Hurdle = {
        Fly = nil,
        Bomb1 = nil,
        Bomb2 = nil,
        Cactus = nil,
    },
    Coin = nil,
    Diamond = nil,
}
local SoundResource = {
    Background = nil,
    Hit = nil,
    Jump = nil,
    Item = nil,
}


--[[ Member Methods ]]--
local LoadBackgroundResource = function ()
    BackgroundResource = love.graphics.newImage("Data/Image/Background/bg.png")
end

local LoadTileResource = function ()
    for i=1, 2 do
        table.insert(TileResource, {})
    end

    TileResource[1] = love.graphics.newImage("Data/Image/Background/tile01.png")
    TileResource[2] = love.graphics.newImage("Data/Image/Background/tile02.png")
end

local LoadCharacterResource = function ()
    CharacterResource.Blue = love.graphics.newImage("Data/Image/Character/Blue/sprite.png")
    CharacterResource.Green = love.graphics.newImage("Data/Image/Character/Green/sprite.png")
    CharacterResource.Red = love.graphics.newImage("Data/Image/Character/Red/sprite.png")
    CharacterResource.Yellow = love.graphics.newImage("Data/Image/Character/Yellow/sprite.png")
end

local LoadHudResource = function ()
    for i=1, #HudResource.Number do
        HudResource.Number[i] = love.graphics.newImage("Data/Image/Hud/Number/" .. tostring(i-1) .. ".png")
    end
    HudResource.Heart.Full = love.graphics.newImage("Data/Image/Hud/heart.png")
    HudResource.Heart.Empty = love.graphics.newImage("Data/Image/Hud/heart_empty.png")
end

local LoadObjectResource = function ()
    ObjectResource.Hurdle.Fly = love.graphics.newImage("Data/Image/Object/Hurdle/Fly/sprite.png")
    ObjectResource.Hurdle.Bomb1 = love.graphics.newImage("Data/Image/Object/Hurdle/bomb01.png")
    ObjectResource.Hurdle.Bomb2 = love.graphics.newImage("Data/Image/Object/Hurdle/bomb02.png")
    ObjectResource.Hurdle.Cactus = love.graphics.newImage("Data/Image/Object/Hurdle/cactus.png")
    ObjectResource.Coin = love.graphics.newImage("Data/Image/Object/coin.png")
    ObjectResource.Diamond = love.graphics.newImage("Data/Image/Object/diamond.png")
end

local LoadSoundResource = function (  )
    SoundResource.Background = love.audio.newSource("Data/Sound/Background.mp3", "stream")
    SoundResource.Hit = love.audio.newSource("Data/Sound/Hit.ogg", "stream")
    SoundResource.Item = love.audio.newSource("Data/Sound/Item.ogg", "stream")
    SoundResource.Jump = love.audio.newSource("Data/Sound/Jump.ogg", "stream")
end



--[[ Constructor ]]--
function ResourceManager:initialize()
    LoadBackgroundResource()
    LoadTileResource()
    LoadCharacterResource()
    LoadHudResource()
    LoadObjectResource()
    LoadSoundResource()
end



--[[ Methods ]]--
function ResourceManager:GetBackgroundResource() return BackgroundResource end
function ResourceManager:GetTileResource() return TileResource end
function ResourceManager:GetCharacterResource() return CharacterResource end
function ResourceManager:GetHudResource() return HudResource end
function ResourceManager:GetObjectResource() return ObjectResource end
function ResourceManager:GetSoundResource() return SoundResource end



return ResourceManager