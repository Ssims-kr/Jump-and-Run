--[[ Global ]]--
ConfigMgr = nil



--[[ Callbaacks ]]--
function love.conf(t)
    t.window.title = "Jump and Run"
    t.window.width = 600
    t.window.height = 480
    t.console = true

    ConfigMgr = t
end