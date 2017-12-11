card_engine = require "/card_engine"
return {
  tree = card_engine.new_card(
    card_engine.layouts.default(
      {r=100,g=10,b=10},
      "Colorfull Circles",
      love.graphics.newImage("/Assets/cardpictures/rings.png"),
      "They are cool, aren't they? +1 Excitement!"
    )
  )
}
