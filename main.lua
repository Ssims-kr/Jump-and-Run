--[[ Included ]]--
local ResourceManager = require("ResourceManager")



--[[ Global ]]--
GameState = require("Script.Library.gamestate")
StateList = { Intro = nil, Game = nil, GameOver = nil }
ResourceMgr = ResourceManager()



function love.load()
    -- State List
    StateList.Intro = require("Intro")
    StateList.Game = require("Game")
    StateList.GameOver = require("GameOver")

    -- GameState
    GameState.registerEvents()
    GameState.switch(StateList.Intro)
end

function love.update(dt)

end

function love.draw()

end