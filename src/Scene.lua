local Scene = CLASS('Scene')
Scene:include(STATEFUL)

Scene:addState('Game')
Scene:addState('Menu')

return Scene
