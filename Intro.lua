local Intro = {}



--[[ Included ]]--
local SYSL_TEXT = require("Script.Library.slog-text")



--[[ Variables ]]--
local BackgroundResource = nil
local TileResource = nil

local ScaleX, ScaleY = 0, 0

local TitleFont = nil
local MessageFont = nil



--[[ Functions ]]--



--[[ Callbacks ]]--
function Intro:init()
    BackgroundResource = ResourceMgr:GetBackgroundResource()
    TileResource = ResourceMgr:GetTileResource()

    ScaleX, ScaleY = (ConfigMgr.window.width / BackgroundResource:getWidth()), (ConfigMgr.window.height / BackgroundResource:getHeight())

    TitleFont = SYSL_TEXT.new("center", {
        color = { 0, 0, 0, 1 },
        font = love.graphics.setNewFont(60),
        print_speed = 0.1,
    })
    TitleFont:send("[shake]Jump [pause=0.3]and Run[/shake]")

    MessageFont = SYSL_TEXT.new("left", {
        color = { 0, 0, 0, 1 },
        font = love.graphics.setNewFont(30),
        print_speed = 0.1,
    })
    MessageFont:send("[pause=2.0]Press enter to start")
end

function Intro:enter(prev)

end

function Intro:leave()

end

function Intro:resume()

end

function Intro:quit()
    MessageFont = nil
    TitleFont = nil
    TileResource = nil
    BackgroundResource = nil
end

function Intro:focus()

end

function Intro:update(dt)
    TitleFont:update(dt)
    MessageFont:update(dt)
end

function Intro:draw()
    -- 배경화면
    love.graphics.draw(BackgroundResource, 0, 0, 0, ScaleX, ScaleY)

    -- 타일 1
    for i=1, math.ceil(ConfigMgr.window.width / TileResource[1]:getWidth()) do
        love.graphics.draw(TileResource[1], 0 + ((i-1) * 18), 350)
    end

    -- 타일 2
    for i=1, math.ceil(ConfigMgr.window.width / TileResource[2]:getWidth()) do
        for j=1, math.ceil( (ConfigMgr.window.height - 368) / TileResource[2]:getHeight()) do
            love.graphics.draw(TileResource[2], 0 + ((i-1) * 18), 368 + ((j-1) * 18))
        end
    end

    -- 제목
    TitleFont:draw(80, 100)

    -- 내용
    MessageFont:draw(150, 300)
end

function Intro:keypressed(key, code)
    if (key == "return") then
        GameState.switch(StateList.Game)
    end
end

function Intro:keyreleased(key, code)

end

function Intro:mousepressed(x, y, mouseBtn)

end

function Intro:mousereleased(x, y, mouseBtn)

end

return Intro