-- ==============================================================================
-- Hammerspoon Configuration
-- ==============================================================================
-- Replaces skhd for hotkey management with yabai
-- ==============================================================================

-- Reload config shortcut
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)
hs.alert.show("Hammerspoon config loaded")

-- ==============================================================================
-- Helper Functions
-- ==============================================================================

-- Execute yabai command
local function yabai(args)
    hs.task.new("/opt/homebrew/bin/yabai", nil, function() return false end, args):start()
end

-- ==============================================================================
-- App Launchers (Cmd + key)
-- ==============================================================================

-- Cmd + Enter -> Open Alacritty
hs.hotkey.bind({"cmd"}, "return", function()
    hs.application.launchOrFocus("Alacritty")
end)

-- Cmd + E -> Open Finder
hs.hotkey.bind({"cmd"}, "e", function()
    hs.application.launchOrFocus("Finder")
end)

-- Cmd + B -> Open Firefox
hs.hotkey.bind({"cmd"}, "b", function()
    hs.application.launchOrFocus("Firefox")
end)


-- ==============================================================================
-- Window Focus (Alt + H/J/K/L)
-- ==============================================================================

hs.hotkey.bind({"alt"}, "h", function()
    yabai({"-m", "window", "--focus", "west"})
end)

hs.hotkey.bind({"alt"}, "j", function()
    yabai({"-m", "window", "--focus", "south"})
end)

hs.hotkey.bind({"alt"}, "k", function()
    yabai({"-m", "window", "--focus", "north"})
end)

hs.hotkey.bind({"alt"}, "l", function()
    yabai({"-m", "window", "--focus", "east"})
end)


-- ==============================================================================
-- Display Focus (Alt + N/M)
-- ==============================================================================

hs.hotkey.bind({"alt"}, "n", function()
    yabai({"-m", "display", "--focus", "west"})
end)

hs.hotkey.bind({"alt"}, "m", function()
    yabai({"-m", "display", "--focus", "east"})
end)


-- ==============================================================================
-- Window Resize (Ctrl + Alt + H/J/K/L)
-- ==============================================================================

hs.hotkey.bind({"ctrl", "alt"}, "h", function()
    yabai({"-m", "window", "--resize", "left:-20:0"})
end)

hs.hotkey.bind({"ctrl", "alt"}, "j", function()
    yabai({"-m", "window", "--resize", "bottom:0:20"})
end)

hs.hotkey.bind({"ctrl", "alt"}, "k", function()
    yabai({"-m", "window", "--resize", "top:0:-20"})
end)

hs.hotkey.bind({"ctrl", "alt"}, "l", function()
    yabai({"-m", "window", "--resize", "right:20:0"})
end)

-- Balance window tree
hs.hotkey.bind({"ctrl", "alt"}, "r", function()
    yabai({"-m", "space", "--balance"})
end)


-- ==============================================================================
-- Window Arrangement (Shift + Alt)
-- ==============================================================================

-- Maximize/zoom window
hs.hotkey.bind({"shift", "alt"}, "m", function()
    yabai({"-m", "window", "--toggle", "zoom-fullscreen"})
end)

-- Swap windows
hs.hotkey.bind({"shift", "alt"}, "j", function()
    yabai({"-m", "window", "--swap", "south"})
end)

hs.hotkey.bind({"shift", "alt"}, "k", function()
    yabai({"-m", "window", "--swap", "north"})
end)

hs.hotkey.bind({"shift", "alt"}, "h", function()
    yabai({"-m", "window", "--swap", "west"})
end)

hs.hotkey.bind({"shift", "alt"}, "l", function()
    yabai({"-m", "window", "--swap", "east"})
end)

-- Rotate layout clockwise
hs.hotkey.bind({"shift", "alt"}, "r", function()
    yabai({"-m", "space", "--rotate", "270"})
end)

-- Flip along y-axis
hs.hotkey.bind({"shift", "alt"}, "y", function()
    yabai({"-m", "space", "--mirror", "y-axis"})
end)

-- Flip along x-axis
hs.hotkey.bind({"shift", "alt"}, "x", function()
    yabai({"-m", "space", "--mirror", "x-axis"})
end)

-- Toggle window float
hs.hotkey.bind({"shift", "alt"}, "d", function()
    yabai({"-m", "window", "--toggle", "float"})
    yabai({"-m", "window", "--grid", "4:4:1:1:2:2"})
end)


-- ==============================================================================
-- Workspace Navigation (Shift + Alt + number)
-- Requires SIP disabled for yabai
-- ==============================================================================

-- Move window to previous/next space
hs.hotkey.bind({"shift", "alt"}, "p", function()
    yabai({"-m", "window", "--space", "prev"})
end)

hs.hotkey.bind({"shift", "alt"}, "n", function()
    yabai({"-m", "window", "--space", "next"})
end)

-- Move window to specific space
hs.hotkey.bind({"shift", "alt"}, "1", function()
    yabai({"-m", "window", "--space", "1"})
end)

hs.hotkey.bind({"shift", "alt"}, "2", function()
    yabai({"-m", "window", "--space", "2"})
end)

hs.hotkey.bind({"shift", "alt"}, "3", function()
    yabai({"-m", "window", "--space", "3"})
end)
