local utils = require "/utils"
local card_manager = {}
card_manager = {
  card_width=100,
  card_height=150,
  draw_element = {
    text = function(element, element_x, element_y)
      if #element.text*5.5>card_manager.card_width then
        local Font = love.graphics.getFont()
        local text_x = 0
        local max_text_width = element.w/Font:getWidth("d") or card_manager.card_width/Font:getWidth("d")
        while true do
          local text = string.sub(element.text, text_x, text_x+max_text_width-1)
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
  },
  assets = {
    deck = love.graphics.newImage("/Assets/deck.png"),
    card = love.graphics.newImage("/Assets/card.png")
  },
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
            love.graphics.draw(card_manager.assets.card, x, y)
            for element_num = 1, #self do
              local element = self[element_num]
              if card_manager.draw_element[element.type] then
                if element.r and element.g and element.b then
                  love.graphics.setColor(element.r, element.g, element.b)
                end
                local element_x = element.x
                local element_y = element.y
                local Font = love.graphics.getFont()
                if element.x == "middle" then
                  local width = 1
                  if element.type == "text" then
                    width = Font:getWidth(element.text)
                  elseif element.type == "image" then
                    width = element.image:getWidth()
                  end
                  element_x = card_manager.card_width/2-width/2
                end
                element_x = element_x + x
                element_y = element_y + y
                card_manager.draw_element[element.type](element, element_x, element_y)
              end
            end
          end,
          is_clicked = function(self, x, y, mouse_x, mouse_y)
            return utils.is_box_clicked(x, y, card_manager.card_width, card_manager.card_height, mouse_x,  mouse_y)
          end
        }
      }
    )
    return card
  end,
  new_deck = function(deck, height_distance_between_cards, width_distance_between_cards)
    setmetatable(
      deck,
      {
        __index = {
          get_card_pos = function(self, card)
            return self.x+height_distance_between_cards*card, self.y+width_distance_between_cards*card
          end,
          draw = function(self)
            if #self==0 then
              love.graphics.draw(card_manager.assets.deck, self.x, self.y)
            else
              local x = height_distance_between_cards
              local y = width_distance_between_cards
              for card_num = 1, #self do
                local card = self[card_num]
                card:draw(self:get_card_pos(card_num))
              end
            end
          end,
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
                if #deck == 0 then

                else
                  for card_num = 1, #deck do
                    local card = deck[card_num]
                    local card_x, card_y = deck:get_card_pos(card_num)
                    if self.timer<=0 and card:is_clicked(card_x, card_y, mouse_x, mouse_y) then
                      self.timer = 0.4
                      if self.grabbed then
                        if self.grabbed.card.play_function then
                          self.grabbed.card.play_function(self.grabbed.card, deck)
                        end
                        table.insert(deck,self.grabbed.card)
                        self.grabbed = nil
                      else
                        if #deck > 0 then
                          local card = deck[card_num]
                          local card_x, card_y = deck:get_card_pos(card_num)
                          self.grabbed = {
                            card = card,
                            offset = {
                              x = mouse_x-card_x,
                              y = mouse_y-card_y
                            }
                          }
                          table.remove(deck, card_num)
                        end
                      end
                      break
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
    default = function(color, title, image, description, runfunction)
      return {
        color=color,
        play_function=runfunction,
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
          w=100,
          r=255,
          g=255,
          b=255
        }
      }
    end
  }
}
return card_manager
