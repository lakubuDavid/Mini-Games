function love.conf(t)
    t.window.title = "Chess - because yes"
    t.window.width = 1024
    t.window.height = 720
    t.window.resizable = true
    t.window.vsync = 0
    t.window.minwidth = 1024
    t.window.minheight = 720

    t.console = false

    t.version = "11.3"
    t.release = true

    t.externalize = false
    t.pause_on_minimize = false
end
