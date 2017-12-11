local card_width = 100
local card_height = 150
local assets = {
  deck = love.graphics.newImage("/Assets/deck.png"),
  card = love.graphics.newImage("/Assets/card.png")
}
local draw_element = {
  text = function(element, element_x, element_y)
    if #element.text*5.5>card_width then
      local text_x = 0
      local max_text_width = element.w/5.5 or card_width/5.5
      while true do
        local text = string.sub(element.text, text_x, text_x+max_text_width-1)
        print(text)
        if text == "" then
          break
        else
          love.graphics.print(text, element_x, element_y+text_x)
        end
        text_x = text_x + max_text_width
      end
    else
      love.graphics.print(element.text, element_x-1, element_y-1)
    end
  end,
  image = function(element, element_x, element_y)
    love.graphics.draw(element.image, element_x, element_y)
  end
}
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
            love.graphics.draw(assets.card, x, y)
            for element_num = 1, #self do
              local element = self[element_num]
              if draw_element[element.type] then
                if element.r and element.g and element.b then
                  love.graphics.setColor(element.r, element.g, element.b)
                end
                local element_x = element.x
                local element_y = element.y
                if element.x == "middle" then
                  local width = 1
                  if element.type == "text" then
                    width = #element.text*5.5
                  elseif element.type == "image" then
                    width = element.image:getWidth()
                  end
                  element_x = card_width/2-width/2
                end
                element_x = element_x + x
                element_y = element_y + y
                draw_element[element.type](element, element_x, element_y)
              end
            end
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
            if #self==0 then
              love.graphics.draw(assets.deck, self.x, self.y)
            else
              local x = 3
              local y = 3
              for card_num = 1, #self do
                local card = self[card_num]
                card:draw(self.x+x*card_num, self.y+y*card_num)
              end
            end
          end,
          is_clicked = function(self, mouse_x, mouse_y)
            return (mouse_x<self.x+card_width-1) and (mouse_y<self.y+card_height-1) and (mouse_y>self.y) and (mouse_x>self.x)
          end
        }
      }
    )
    return deck
  end,
  new_game = function(decks)
    decks.timer = 0
    setmetatable(
      decks,
      {
        __index = {
          draw = function(self)
            for deck_num = 1, #self do
              self[deck_num]:draw()
            end
            if self.grabbed then
              self.grabbed.card:draw(
                love.mouse.getX()-self.grabbed.offset.x,
                love.mouse.getY()-self.grabbed.offset.y,
                self.w,
                self.h
              )
            end
          end,
          update = function(self, dt)
            mouse_x, mouse_y = love.mouse.getPosition()
            if self.timer>0 then self.timer = self.timer-dt end
            if love.mouse.isDown("l") then
              for deck_num = 1, #self do
                local deck = self[deck_num]
                if deck:is_clicked(mouse_x, mouse_y) and self.timer<=0 then
                  self.timer = 0.4
                  if self.grabbed then
                    table.insert(deck,self.grabbed.card)
                    self.grabbed = nil
                  else
                    if #deck > 0 then
                      self.grabbed = {
                        card = deck[#deck],
                        offset = {
                          x = mouse_x-deck.x,
                          y = mouse_y-deck.y
                        }
                      }
                      deck[#deck] = nil
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
  end,
  layouts = {
    default = function(color, title, image, description)
      return {
        color=color,
        {
          type="text",
          text=title,
          x="middle",
          y=13,
          r=255,
          g=255,
          b=255
        },
        {
          type="image",
          image=image,
          x="middle",
          y=25
        },
        {
          type="text",
          text=description,
          x=10,
          y=80,
          w=70,
          r=255,
          g=255,
          b=255
        }
      }
    end
  }
}
