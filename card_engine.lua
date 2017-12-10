local card_width = 100
local card_height = 150
return {
  card_width=card_width,
  card_height=card_height,
  new_card = function(card)
    setmetatable(
      card,
      {
        __index = {
          draw = function(self, x, y)
            if self.color then
              local color = self.color
              love.graphics.setColor(color.r, color.g, color.b)
            end
            love.graphics.rectangle("fill", x, y, card_width, card_height)
          end
        }
      }
    )
    return card
  end,
  new_deck = function(deck)
    setmetatable(
      deck,
      {
        __index = {
          draw = function(self)
            local x = 3
            local y = 3
            for card_num = 1, #self do
              local card = self[card_num]
              card:draw(self.x+x*card_num, self.y+y*card_num)
            end
          end
        }
      }
    )
    return deck
  end,
  new_game = function(decks)
    setmetatable(
      decks,
      {
        __index = {
          draw = function(self)
            for deck_num = 1, #self do
              self[deck_num]:draw()
            end
            if self.grabbed then
              self.grabbed:draw(love.mouse.getX(), love.mouse.getY(), self.w, self.h)
            end
          end,
          update = function(self, dt)
            if love.mouse.isDown("l") then
              mouse_x, mouse_y = love.mouse.getPosition()
              for deck_num = 1, #self do
                local deck = self[deck_num]
                for card_num = 1, #self[deck_num] do
                  local card = deck[card_num]
                  if mouse_x>deck.x and mouse_y>deck.y then
                    if mouse_x<deck.x+card_width-1 and mouse_y<deck.y+card_height-1 then
                      self.grabbed = card
                    end
                  end
                end
              end
            end
          end
        }
      }
    )
    return decks
  end
}
