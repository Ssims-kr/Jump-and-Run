local GameOver = {}



--[[ Included ]]--
local SYSL_TEXT = require("Script.Library.slog-text")



--[[ Variables ]]--
local PrevScene = nil
local TitleFont = nil
local MessageFont = nil



--[[ Callbacks ]]--
function GameOver:init()
    TitleFont = SYSL_TEXT.new("center", {
        color = { 0, 0, 0, 1 },
        font = love.graphics.setNewFont(60),
        print_speed = 0.1,
    })
    TitleFont:send("[bounce]Game [pause=0.3]Over[/bounce]")
    
    MessageFont = SYSL_TEXT.new("center", {
        color = { 0, 0, 0, 1 },
        font = love.graphics.setNewFont(30),
        print_speed = 0.1,
    })
    MessageFont:send("[pause=1.5][bounce]Press [rainbow]enter[/rainbow] to retry[/bounce]")
end

function GameOver:enter(prev)
    PrevScene = prev
end

function GameOver:leave()

end

function GameOver:resume()

end

function GameOver:quit()
    MessageFont = nil
    TitleFont = nil
    PrevScene = nil
    SYSL_TEXT = nil
end

function GameOver:focus()

end

function GameOver:update(dt)
    TitleFont:update(dt)
    MessageFont:update(dt)
end

function GameOver:draw()
    PrevScene:draw()

    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", 0, 0, ConfigMgr.window.width, ConfigMgr.window.height)
    love.graphics.setColor(1, 1, 1, 1)

    TitleFont:draw(130, 100)
    MessageFont:draw(150, 300)
end

function GameOver:keypressed(key, code)
    if (key == "return") then
        GameState.pop()
    end
end

function GameOver:keyreleased(key, code)

end

function GameOver:mousepressed(x, y, mouseBtn)

end

function GameOver:mousereleased(x, y, mouseBtn)

end

return GameOver