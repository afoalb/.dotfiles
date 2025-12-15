-- ==============================================================================
-- Hammerspoon Configuration
-- ==============================================================================
--
-- Key binding schema:
--   Option          = Focus/Select
--   Option + Shift  = Resize
--   Option + Ctrl   = Move/Place
--
-- ==============================================================================

-- Reload config shortcut
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)
hs.alert.show("Hammerspoon config loaded")


-- ==============================================================================
-- Helper Functions
-- ==============================================================================

local function yabai(args)
    hs.task.new("/opt/homebrew/bin/yabai", nil, function() return false end, args):start()
end


-- ==============================================================================
-- App Launchers (Cmd + key)
-- ==============================================================================

-- Cmd + Enter -> Alacritty
hs.hotkey.bind({"cmd"}, "return", function()
    hs.application.launchOrFocus("Alacritty")
end)

-- Cmd + E -> Finder
hs.hotkey.bind({"cmd"}, "e", function()
    hs.application.launchOrFocus("Finder")
end)

-- Cmd + B -> Firefox
hs.hotkey.bind({"cmd"}, "b", function()
    hs.application.launchOrFocus("Firefox")
end)


-- ==============================================================================
-- OPTION: Focus/Select
-- ==============================================================================

-- Option + hjkl: Focus window in direction
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

-- Option + n/m: Focus display
hs.hotkey.bind({"alt"}, "n", function()
    yabai({"-m", "display", "--focus", "west"})
end)

hs.hotkey.bind({"alt"}, "m", function()
    yabai({"-m", "display", "--focus", "east"})
end)


-- ==============================================================================
-- OPTION + SHIFT: Resize
-- ==============================================================================

-- Option + Shift + hjkl: Resize window in direction
hs.hotkey.bind({"alt", "shift"}, "h", function()
    yabai({"-m", "window", "--resize", "left:-20:0"})
end)

hs.hotkey.bind({"alt", "shift"}, "j", function()
    yabai({"-m", "window", "--resize", "bottom:0:20"})
end)

hs.hotkey.bind({"alt", "shift"}, "k", function()
    yabai({"-m", "window", "--resize", "top:0:-20"})
end)

hs.hotkey.bind({"alt", "shift"}, "l", function()
    yabai({"-m", "window", "--resize", "right:20:0"})
end)

-- Option + Shift + f: Fullscreen (maximize)
hs.hotkey.bind({"alt", "shift"}, "f", function()
    yabai({"-m", "window", "--toggle", "zoom-fullscreen"})
end)

-- Option + Shift + r: Restore equilibrium (balance)
hs.hotkey.bind({"alt", "shift"}, "r", function()
    yabai({"-m", "space", "--balance"})
end)


-- ==============================================================================
-- OPTION + CTRL: Move/Place
-- ==============================================================================

-- Option + Ctrl + hjkl: Swap window in direction
hs.hotkey.bind({"alt", "ctrl"}, "h", function()
    yabai({"-m", "window", "--swap", "west"})
end)

hs.hotkey.bind({"alt", "ctrl"}, "j", function()
    yabai({"-m", "window", "--swap", "south"})
end)

hs.hotkey.bind({"alt", "ctrl"}, "k", function()
    yabai({"-m", "window", "--swap", "north"})
end)

hs.hotkey.bind({"alt", "ctrl"}, "l", function()
    yabai({"-m", "window", "--swap", "east"})
end)

-- Option + Ctrl + r: Rotate layout
hs.hotkey.bind({"alt", "ctrl"}, "r", function()
    yabai({"-m", "space", "--rotate", "270"})
end)

-- Option + Ctrl + y/x: Mirror layout
hs.hotkey.bind({"alt", "ctrl"}, "y", function()
    yabai({"-m", "space", "--mirror", "y-axis"})
end)

hs.hotkey.bind({"alt", "ctrl"}, "x", function()
    yabai({"-m", "space", "--mirror", "x-axis"})
end)

-- Option + Ctrl + d: Toggle float
hs.hotkey.bind({"alt", "ctrl"}, "d", function()
    yabai({"-m", "window", "--toggle", "float"})
    yabai({"-m", "window", "--grid", "4:4:1:1:2:2"})
end)

-- Option + Ctrl + p/n: Move window to prev/next space
hs.hotkey.bind({"alt", "ctrl"}, "p", function()
    yabai({"-m", "window", "--space", "prev"})
end)

hs.hotkey.bind({"alt", "ctrl"}, "n", function()
    yabai({"-m", "window", "--space", "next"})
end)

-- Option + Ctrl + 1/2/3: Move window to specific space
hs.hotkey.bind({"alt", "ctrl"}, "1", function()
    yabai({"-m", "window", "--space", "1"})
end)

hs.hotkey.bind({"alt", "ctrl"}, "2", function()
    yabai({"-m", "window", "--space", "2"})
end)

hs.hotkey.bind({"alt", "ctrl"}, "3", function()
    yabai({"-m", "window", "--space", "3"})
end)


-- ==============================================================================
-- Browser Shortcuts
-- ==============================================================================

-- Browser bundle IDs for reliable detection
local browserBundleIDs = {
    ["org.mozilla.firefox"] = true,
    ["org.mozilla.firefoxdeveloperedition"] = true,
    ["com.google.Chrome"] = true,
    ["com.apple.Safari"] = true,
    ["company.thebrowser.Browser"] = true,  -- Arc
    ["com.brave.Browser"] = true,
    ["com.microsoft.edgemac"] = true,
}

-- Ctrl + L -> Focus URL bar in browsers (sends Cmd+L)
-- In non-browser apps, pass through the original Ctrl+L (e.g., clear screen in terminals)
local ctrlLTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    local keyCode = event:getKeyCode()

    -- Check if Ctrl+L (keyCode 37 = 'l')
    if flags.ctrl and not flags.cmd and not flags.alt and not flags.shift and keyCode == 37 then
        local app = hs.application.frontmostApplication()
        if app and browserBundleIDs[app:bundleID()] then
            -- In browser: send Cmd+L and block original event
            hs.eventtap.keyStroke({"cmd"}, "l", 0)
            return true  -- Block the original Ctrl+L
        end
    end

    -- Pass through all other keypresses (including Ctrl+L in non-browsers)
    return false
end)
ctrlLTap:start()
