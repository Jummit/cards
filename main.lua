function love.load()
  card_engine = require "/card_engine"
  card_manager = require "/card_manager"
  game = card_manager.game
end

function love.draw()
  love.graphics.setBackgroundColor(255, 255, 255)
  love.graphics.clear()
  game:draw()
end

function love.update(dt)
  game:update(dt)
  if love.keyboard.isDown("escape") then love.event.quit("1") end
end
