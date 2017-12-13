local card_engine = require "/card_engine"
local card_manager = {}
card_manager = {}
card_manager.cards = {
  circles = card_engine.new_card(
    card_engine.layouts.default(
      {r=0,g=10,b=160},
      "Colorfull Circles",
      love.graphics.newImage("/Assets/cardpictures/rings.png"),
      "They are cool, aren't they? +1 Excitement!",
      function(self, deck)
        print(self[1].text.." was layed on "..deck.title)
      end
    )
  ),
  tree = card_engine.new_card(
    card_engine.layouts.default(
      {r=0,g=200,b=0},
      "Christmas tree",
      love.graphics.newImage("/Assets/cardpictures/rings.png"),
      "Wonderfull mighty christmas is comming!"
    )
  )
}
card_manager.game = card_engine.new_game(
  {
    card_engine.new_deck(
      {
        x=100,
        y=200,
        title="city",

        card_manager.cards.circles,
        card_manager.cards.circles,
        card_manager.cards.circles
      },
      100,
      0
    ),
    card_engine.new_deck(
      {
        x=10,
        y=100,
        title="deck",
        card_manager.cards.tree,
        card_manager.cards.tree
      },
      3,
      3
    )
  }
)
return card_manager
