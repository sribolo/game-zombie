

function love.load()

sprites = {}
sprites.background = love.graphics.newImage('sprites/background.png')
sprites.bullet = love.graphics.newImage('sprites/bullet.png')
sprites.player = love.graphics.newImage('sprites/player.png')
sprites.zombie = love.graphics.newImage('sprites/zombie.png')

--gunShot = love.audio.newSource("sprites/gunshot.mp3", "static")


player = {}
player.x = love.graphics.getWidth() / 2
player.y = love.graphics.getHeight() / 2
player.speed = 180
rotation = 0
score = 0
zombies = {} -- index 0, 1,2,3,4, -- value zombie
bullets = {}
myFont= love.graphics.newFont(30)
gameState = 0
maxTime = 2
timer = maxTime

end

function love.update(dt)






  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end

  if love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  end
  if love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  end
  if love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  end
  rotation = rotation + 0.1

  for i,z in pairs(zombies) do
    z.x = z.x + (math.cos(ZombiePlayerAngle(z)) * z.speed * dt)
    z.y = z.y + (math.sin(ZombiePlayerAngle(z)) * z.speed * dt)

      if distanceFrom(z.x,z.y,player.x,player.y) < 30 then
        for i,z in pairs(zombies) do
            zombies[i] = nil
            gameState = 0
        end
      end

  end

  for i,b in pairs(bullets) do
      b.x = b.x + (math.cos(b.direction) * b.speed * dt)
      b.y = b.y + (math.sin(b.direction) * b.speed * dt)
  end


for i,z in ipairs(zombies) do
  for j,b in ipairs(bullets) do
    if distanceFrom(z.x, z.y, b.x, b.y) < 20 then
      z.dead = true
      b.dead = true
      score = score + 1
    end
  end
end

for i=#zombies, 1,-1 do
  local z = zombies[i]
  if z.dead == true then
    table.remove(zombies,i)
  end
end

for i=#bullets, 1,-1 do
  local b = bullets[i]
  if b.dead == true then
    table.remove(bullets,i)
  end
end

if gameState == 1 then
  timer = timer - dt
  if timer <= 0 then
    spawnZombie()
    maxTime = 0.95 * maxTime
    timer = maxTime
  end
end

end


function love.draw()

  love.graphics.draw(sprites.background,0,0)


  if gameState == 0 then
     love.graphics.setFont(myFont)
     love.graphics.printf("Click anywhere to start", 0, 50, love.graphics.getWidth(), "center")
  end

    love.graphics.printf("Score " .. score,0,love.graphics.getHeight()-100, love.graphics.getWidth(),"center")


  love.graphics.draw(sprites.player,player.x ,player.y,playerMouseAngle(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2)

  for i,z in pairs(zombies) do
  love.graphics.draw(sprites.zombie,z.x ,z.y,ZombiePlayerAngle(z),nil,nil,sprites.zombie:getWidth()/2,sprites.zombie:getHeight()/2)
  end

  for i,b in pairs(bullets) do
    love.graphics.draw(sprites.bullet, b.x,b.y,nil,0.5,nil,sprites.bullet:getWidth()/2,sprites.bullet:getHeight()/2)
  end

  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
      table.remove(bullets, i)
    end

  end

end


function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    spawnZombie()
  end
end

--function love.keypressed(key, scancode, isrepeat)
--end

function love.keyreleased(key)

    if key == "b" and gameState == 1 then
      spawnBullet()
    elseif key == "b" and gameState == 0 then
      gameState =  1
      maxTime = 2
      timer = maxTime
      score = 0

end

end


function love.mousepressed(x, y, button, isTouch)
    if button == 1 and gameState == 1 then
    --  playSound(gunShot)
      spawnBullet()
    elseif button == 1 and gameState == 0 then
      gameState =  1
      maxTime = 2
      timer = maxTime
      score = 0


    end
end

function playSound(sound)

sound:setPitch(5)
sound:setVolume(0.1)
sound:play()


end






function spawnBullet()

  local bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 500
  bullet.dead = false
  bullet.direction = playerMouseAngle()
  table.insert(bullets,bullet)

end


function spawnZombie()
  local zombie = {}
  zombie.x = math.random(0,love.graphics.getWidth())
  zombie.y = math.random(0,love.graphics.getHeight())
  zombie.speed = 60
  zombie.dead = false
  table.insert(zombies,zombie)

end


function ZombiePlayerAngle(enemy)
    return math.atan2(player.y - enemy.y, player.x - enemy.x )
end


function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX() ) + math.pi
end



function distanceFrom(x1,y1,x2,y2)
  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
