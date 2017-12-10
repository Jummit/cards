function love.load()
  cardengine = require "/card_engine"
  cards = require "/card_manager"
  game = cardengine.new_game(
    {
      cardengine.new_deck(
        {
          x=100,
          y=200,
          cards.tree
        }
      )
    }
  )
end

function love.draw()
  game:draw()
end

function love.update(dt)
  game:update(dt)
  if love.keyboard.isDown("escape") then love.event.quit("1") end
end
