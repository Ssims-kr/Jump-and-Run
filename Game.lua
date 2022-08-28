local Game = {}



--[[ Included ]]--
local Anim8 = require("Script.Library.anim8")
local STALKER_X = require("Script.Library.STALKER-X.Camera")
local WINDFIELD = require("Script.Library.windfield")


--[[ Variables ]]--
local BackgroundResource = nil
local TileResource = nil
local CharacterResource = nil
local HudResource = nil
local ObjectResource = nil
local SoundResource = nil

local Collision = nil
local CollisionList = {
    Underground = nil,

}

local Player = {
    X = 0,
    Y = 0,
    OriginX = 0,
    OriginY = 0,
    Image = nil,
    Collider = nil,
    Grid = nil,
    Animation = nil,
    IsJump = false,
    Heart = 0,
    Jump = 0,
}

local Background = {
    ScaleX = 0,
    ScaleY = 0,
}
local Tile1 = {}
local Tile2 = {}
local GameObject = {}

local ChangeCnt = 0
local Score = 0
local GameGravity = 300

local GameCamera = nil



--[[ Functions ]]--
local InitPlayer = function ()
    Player.X = 100
    Player.Y = 330
    Player.Image = CharacterResource.Blue
    Player.Collider = Collision:newRectangleCollider(Player.X, Player.Y, 24, 24)
    Player.Collider:setCollisionClass("Player")
    Player.Collider:setFixedRotation(true)
    Player.Grid = Anim8.newGrid(24, 24, Player.Image:getWidth(), Player.Image:getHeight())
    Player.Animation = Anim8.newAnimation(Player.Grid('1-2', 1), 0.2)
    Player.OriginX = Player.Image:getWidth() / 2
    Player.OriginY = Player.Image:getHeight() / 2
    Player.Heart = 3
    Player.Jump = -160
end

local DrawBackground = function ()
    -- 배경화면
    love.graphics.draw(BackgroundResource, 0, 0, 0, Background.ScaleX, Background.ScaleY)

    -- 타일 1
    for i=1, #Tile1 do
        love.graphics.draw(Tile1[i].Image, Tile1[i].X, Tile1[i].Y)
    end

    -- 타일 2
    for i=1, #Tile2 do
        love.graphics.draw(Tile2[i].Image, Tile2[i].X, Tile2[i].Y)
    end
end

local DrawHeart = function ()
    for i=1, 3 do
        love.graphics.draw(HudResource.Heart.Empty, 30 + ((i-1) * 20), 50)
    end

    for i=1, Player.Heart do
        love.graphics.draw(HudResource.Heart.Full, 30 + ((i-1) * 20), 50)
    end
end

local DrawScore = function ()
    local str = tostring(Score)

    for i=1, #str do
        local idx = tonumber(string.sub(str, i, i)) + 1
        love.graphics.draw(HudResource.Number[idx], 30 + ((i-1) * 15), 30)
    end
end

local AddScoreItem = function ()
    local GameObjectCnt = #GameObject

    table.insert(GameObject, {
        X = 500,
        Y = love.math.random(300, 330),
        IsItem = true,
        IsFly = false,
    })
    GameObject[GameObjectCnt + 1].ID = GameObjectCnt + 1
    GameObject[GameObjectCnt + 1].Collider = Collision:newRectangleCollider(GameObject[GameObjectCnt + 1].X, GameObject[GameObjectCnt + 1].Y, 18, 18)
    GameObject[GameObjectCnt + 1].Collider:setGravityScale(0)

    if (love.math.random(0, 1) == 0) then
        GameObject[GameObjectCnt + 1].Image = ObjectResource.Coin
        GameObject[GameObjectCnt + 1].Collider:setCollisionClass("Item")
    else
        GameObject[GameObjectCnt + 1].Image = ObjectResource.Diamond
        GameObject[GameObjectCnt + 1].Collider:setCollisionClass("Item")
    end
end

local AddHurdle = function ()
    local GameObjectCnt = #GameObject

    table.insert(GameObject, {
        X = 550,
        Y = 330,
        IsItem = false,
        IsFly = false,
    })
    GameObject[GameObjectCnt + 1].ID = GameObjectCnt + 1

    local randNum = love.math.random(0, 3)
    if (randNum == 0) then
        GameObject[GameObjectCnt + 1].Y = love.math.random(290, 330)
        GameObject[GameObjectCnt + 1].Image = ObjectResource.Hurdle.Fly
        GameObject[GameObjectCnt + 1].Collider = Collision:newCircleCollider(GameObject[GameObjectCnt + 1].X, GameObject[GameObjectCnt + 1].Y + 9, 7)
        GameObject[GameObjectCnt + 1].Collider:setGravityScale(0)
        GameObject[GameObjectCnt + 1].Collider:setCollisionClass("Hurdle")
        GameObject[GameObjectCnt + 1].Grid = Anim8.newGrid(24, 24, GameObject[GameObjectCnt + 1].Image:getWidth(), GameObject[GameObjectCnt + 1].Image:getHeight())
        GameObject[GameObjectCnt + 1].Animation = Anim8.newAnimation(GameObject[GameObjectCnt + 1].Grid('1-3', 1), 0.2)
        GameObject[GameObjectCnt + 1].IsFly = true
    elseif (randNum == 1) then
        GameObject[GameObjectCnt + 1].Image = ObjectResource.Hurdle.Bomb1
        GameObject[GameObjectCnt + 1].Collider = Collision:newCircleCollider(GameObject[GameObjectCnt + 1].X, GameObject[GameObjectCnt + 1].Y + 9, 7)
        GameObject[GameObjectCnt + 1].Collider:setGravityScale(0)
        GameObject[GameObjectCnt + 1].Collider:setCollisionClass("Hurdle")
    elseif (randNum == 2) then
        GameObject[GameObjectCnt + 1].Image = ObjectResource.Hurdle.Bomb2
        GameObject[GameObjectCnt + 1].Collider = Collision:newCircleCollider(GameObject[GameObjectCnt + 1].X, GameObject[GameObjectCnt + 1].Y + 9, 7)
        GameObject[GameObjectCnt + 1].Collider:setGravityScale(0)
        GameObject[GameObjectCnt + 1].Collider:setCollisionClass("Hurdle")
    elseif (randNum == 3) then
        GameObject[GameObjectCnt + 1].Image = ObjectResource.Hurdle.Cactus
        GameObject[GameObjectCnt + 1].Collider = Collision:newCircleCollider(GameObject[GameObjectCnt + 1].X, GameObject[GameObjectCnt + 1].Y + 9, 7)
        GameObject[GameObjectCnt + 1].Collider:setGravityScale(0)
        GameObject[GameObjectCnt + 1].Collider:setCollisionClass("Hurdle")
    else

    end
end

local Process = function (dt)
    if (Player.Heart <= 0) then GameState.push(StateList.GameOver) end

    if (Player.Collider:enter("Underground")) then
        Player.IsJump = false
    end

    -- 맵 움직임
    for i=1, #Tile1 do
        Tile1[i].X = Tile1[i].X - 1

        if (Tile1[i].X < -Tile1[i].Image:getWidth()) then
            Tile1[i].X = ConfigMgr.window.width
        end
    end
    for i=1, #Tile2 do
        Tile2[i].X = Tile2[i].X - 1

        if (Tile2[i].X < -Tile2[i].Image:getWidth()) then
            Tile2[i].X = ConfigMgr.window.width
        end
    end

    -- 플레이어의 좌표 설정
    Player.X, Player.Y = Player.Collider:getPosition()

    -- 플레이어 애니메이션 업데이트
    Player.Animation:update(dt)

    -- 점수 증가
    Score = Score + 1

    -- 아이템 추가
    if (Score % 100 == 0) then
        AddScoreItem()
    end

    -- 함정 추가
    if (Score % 250 == 0) then
        AddHurdle()
    end

    -- 오브젝트 처리
    for i=1, #GameObject do
        if (GameObject[i] ~= nil and GameObject[i].Collider ~= nil) then
            GameObject[i].X, GameObject.Y = GameObject[i].Collider:getPosition()
            GameObject[i].Collider:setLinearVelocity(-100, 0)

            -- 오브젝트 애니메이션 업데이트
            if (GameObject[i].IsFly == true) then GameObject[i].Animation:update(dt) end

            -- 왼쪽 끝에 닿으면 제거
            if (GameObject[i].X <= 0) then
                GameObject[i].Collider:destroy()
                GameObject[i] = nil
                table.remove(GameObject, i)
                break
            end

            -- 닿으면 점수 추가
            if (GameObject[i].IsItem == true and GameObject[i].Collider:enter("Player")) then
                Score = Score + 50
                GameObject[i].Collider:destroy()
                table.remove(GameObject, i)
                SoundResource.Item:play()
                break
            end
            
            -- 닿으면 하트 감소
            if (GameObject[i].IsItem == false and GameObject[i].Collider:enter("Player")) then
                Player.Heart = Player.Heart - 1
                
                -- 카메라 흔들기
                GameCamera:shake(3, 1, 60)

                SoundResource.Hit:play()
            end
        end
    end
end



--[[ Callbacks ]]--
function Game:init()
    -- 리소스 불러오기
    BackgroundResource = ResourceMgr:GetBackgroundResource()
    TileResource = ResourceMgr:GetTileResource()
    CharacterResource = ResourceMgr:GetCharacterResource()
    HudResource = ResourceMgr:GetHudResource()
    ObjectResource = ResourceMgr:GetObjectResource()
    SoundResource = ResourceMgr:GetSoundResource()

    -- STALKER-X
    GameCamera = STALKER_X()

    -- 충돌
    Collision = WINDFIELD.newWorld(0, 0)
    Collision:setGravity(0, GameGravity)
    Collision:addCollisionClass("Underground")
    Collision:addCollisionClass("Hurdle")
    Collision:addCollisionClass("Item")
    Collision:addCollisionClass("Player", {ignores={"Hurdle", "Item"}})

    CollisionList.Underground = Collision:newLineCollider(0, 350, ConfigMgr.window.width, 350)
    CollisionList.Underground:setType("static")
    CollisionList.Underground:setCollisionClass("Underground")

    -- 배경화면 스케일
    Background.ScaleX, Background.ScaleY = ConfigMgr.window.width / BackgroundResource:getWidth(), ConfigMgr.window.height / BackgroundResource:getHeight()

    -- 타일 1, 2
    for i=1, math.ceil(ConfigMgr.window.width / TileResource[1]:getWidth())+1 do
        table.insert(Tile1, { 
            Image = TileResource[1],
            X = 0 + ((i-1) * 18),
            Y = 350,
        })
    end
    for i=1, math.ceil(ConfigMgr.window.width / TileResource[2]:getWidth())+1 do
        for j=1, math.ceil( (ConfigMgr.window.height - 368) / TileResource[2]:getHeight()) do
            table.insert(Tile2, {
                Image = TileResource[2],
                X = 0 + ((i-1) * 18),
                Y = 368 + ((j-1) * 18),
            })
        end
    end

    -- 플레이어 초기화
    InitPlayer()
end

function Game:enter(prev)
    -- 배경음악 재생
    SoundResource.Background:setLooping(true)
    SoundResource.Background:play()
end

function Game:leave()
    SoundResource.Background:stop()
end

function Game:resume()
    Player.Heart = 3
    Score = 0
    for i=1, #GameObject do
        GameObject[i].Collider:destroy()
        GameObject[i] = nil
    end
    GameObject = nil
    GameObject = {}
end

function Game:quit()
    GameCamera = nil
    for i=1, #GameObject do
        GameObject[i].Collider:destroy()
        GameObject[i] = nil
    end
    GameObject = nil
    Tile2 = nil
    Tile1 = nil
    Background = nil
    Player.Collider:destroy()
    Player = nil
    CollisionList = nil
    Collision:destroy()
    Collision = nil
    SoundResource = nil
    ObjectResource = nil
    HudResource = nil
    CharacterResource = nil
    TileResource = nil
    Background = nil
    WINDFIELD = nil
    STALKER_X = nil
    Anim8 = nil
end

function Game:focus()

end

function Game:update(dt)
    -- 충돌
    Collision:update(dt)

    -- 카메라
    GameCamera:update(dt)

    Process(dt)
end

function Game:draw()
    GameCamera:attach()
        DrawBackground()

        DrawHeart()
        DrawScore()

        Player.Animation:draw(Player.Image, Player.X - 12, Player.Y, 0, -1, 1, Player.OriginX, Player.OriginY)

        for i=1, #GameObject do
            if (GameObject[i].IsFly == true) then
                GameObject[i].Animation:draw(GameObject[i].Image, GameObject[i].X - 24, GameObject[i].Y + 12, 0, -1, 1, GameObject[i].Image:getWidth() / 2, GameObject[i].Image:getHeight() / 2)
            else
                love.graphics.draw(GameObject[i].Image, GameObject[i].X - (GameObject[i].Image:getWidth() / 2), GameObject[i].Y)
            end
        end
    GameCamera:detach()
    GameCamera:draw()

    -- 충돌 라인
    -- Collision:draw()
end

function Game:keypressed(key, code)
    -- 캐릭터 변경
    if (key == "f1") then
        ChangeCnt = ChangeCnt + 1
        if (ChangeCnt > 3) then ChangeCnt = 0 end

        if (ChangeCnt == 0) then Player.Image = CharacterResource.Blue end
        if (ChangeCnt == 1) then Player.Image = CharacterResource.Green end
        if (ChangeCnt == 2) then Player.Image = CharacterResource.Red end
        if (ChangeCnt == 3) then Player.Image = CharacterResource.Yellow end
    end

    -- 점프
    if (Player.IsJump == false) then
        if (key == "space") then
            Player.Collider:setLinearVelocity(0, Player.Jump)
            Player.IsJump = true
            SoundResource.Jump:play()
        end
    end
end

function Game:keyreleased(key, code)

end

function Game:mousepressed(x, y, mouseBtn)

end

function Game:mousereleased(x, y, mouseBtn)

end



return Game