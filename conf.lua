function love.conf(t)

  io.stdout:setvbuf("no")
  t.window.width      = 1024
  t.window.height     = 800

  t.title             = "WOADTOAD 48 HR"
  t.author            = "WOADTOAD"
  t.identity          = "WOADTOADGM"
  t.console           = true

  t.modules.joystick  = true
  t.modules.audio     = true
  t.modules.keyboard  = true
  t.modules.event     = true
  t.modules.image     = true
  t.modules.graphics  = true
  t.modules.timer     = true
  t.modules.mouse     = true
  t.modules.sound     = true
  t.modules.physics   = true
  t.window.vsync      = true
  t.window.resizable  = false
  t.window.borderless = false
  t.window.srgb       = false
  --High DPI doesn't work on high res screens yet.
  t.window.highdpi    = true

  print("HELLO TEAM WOADTOAD, WELOME TO THE 48 HOUR GAME CHALLENGE FRAMEWORK, WE HOPE YOU ENJOY YOUR DEV EXPERIENCE")

end
