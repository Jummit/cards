function love.load()
  card_engine = require "/card_engine"
  cards = require "/card_manager"
  game = card_engine.new_game(
    {
      card_engine.new_deck(
        {
          x=100,
          y=200,
          cards.tree
        }
      ),
      card_engine.new_deck(
        {
          x=10,
          y=100
        }
      )
    }
  )
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
