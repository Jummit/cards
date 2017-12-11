card_engine = require "/card_engine"
return {
  tree = card_engine.new_card(
    {
      color={r=100,g=10,b=10},
      {
        type="text",
        text="Colorfull Circles",
        x="middle",
        y=13,
        r=255,
        g=255,
        b=255
      },
      {
        type="image",
        image=love.graphics.newImage("/Assets/cardpictures/rings.png"),
        x=8,
        y=25
      }
    }
  )
}
