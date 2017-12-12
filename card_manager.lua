local card_engine = require "/card_engine"
local card_manager = {}
card_manager = {}
card_manager.cards = {
  tree = card_engine.new_card(
    card_engine.layouts.default(
      {r=100,g=10,b=10},
      "Colorfull Circles",
      love.graphics.newImage("/Assets/cardpictures/rings.png"),
      "They are cool, aren't they? +1 Excitement!",
      function(self, deck)
        print(self[1].text.." was layed on "..deck.title)
      end
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

        card_manager.cards.tree
      }
    ),
    card_engine.new_deck(
      {
        x=10,
        y=100,
        title="deck"
      }
    )
  }
)
return card_manager
