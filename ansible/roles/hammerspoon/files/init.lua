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
hs.hotkey.bind({"option", "ctrl", "shift"}, "R", function()
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

hs.hotkey.bind({"option"}, "return", function()
    hs.application.launchOrFocus("Alacritty")
end)

hs.hotkey.bind({"option"}, "e", function()
    hs.application.launchOrFocus("Finder")
end)

hs.hotkey.bind({"option"}, "b", function()
    hs.application.launchOrFocus("Firefox")
end)

-- ==============================================================================
-- OPTION: Window selection
-- ==============================================================================

-- Option + hjkl: Focus window in direction
hs.hotkey.bind({"option"}, "h", function()
    yabai({"-m", "window", "--focus", "west"})
end)

hs.hotkey.bind({"option"}, "j", function()
    yabai({"-m", "window", "--focus", "south"})
end)

hs.hotkey.bind({"option"}, "k", function()
    yabai({"-m", "window", "--focus", "north"})
end)

hs.hotkey.bind({"option"}, "l", function()
    yabai({"-m", "window", "--focus", "east"})
end)

-- Option + n/m: Focus display
hs.hotkey.bind({"option"}, "n", function()
    yabai({"-m", "display", "--focus", "west"})
end)

hs.hotkey.bind({"option"}, "p", function()
    yabai({"-m", "display", "--focus", "east"})
end)

-- + h: Hide (minimize) window
hs.hotkey.bind({"option"}, "m", function()
    local app = hs.application.frontmostApplication()
    if app then
        app:hide()
    end
end)

-- + f: Fullscreen (maximize)
hs.hotkey.bind({"option"}, "f", function()
    yabai({"-m", "window", "--toggle", "zoom-fullscreen"})
end)

-- + d: Detach (toggle float)
hs.hotkey.bind({"option"}, "d", function()
    yabai({"-m", "window", "--toggle", "float"})
    yabai({"-m", "window", "--grid", "4:4:1:1:2:2"})
end)


-- ==============================================================================
-- OPTION + SHIFT: Resize
-- ==============================================================================

-- + hjkl: Resize window in direction
hs.hotkey.bind({"option", "shift"}, "h", function()
    yabai({"-m", "window", "--resize", "left:-20:0"})
end)

hs.hotkey.bind({"option", "shift"}, "j", function()
    yabai({"-m", "window", "--resize", "bottom:0:20"})
end)

hs.hotkey.bind({"option", "shift"}, "k", function()
    yabai({"-m", "window", "--resize", "top:0:-20"})
end)

hs.hotkey.bind({"option", "shift"}, "l", function()
    yabai({"-m", "window", "--resize", "right:20:0"})
end)

-- + r: Restore equilibrium (balance)
hs.hotkey.bind({"option", "shift"}, "r", function()
    yabai({"-m", "space", "--balance"})
end)


-- ==============================================================================
-- OPTION + CTRL: Move/Place + Other Actions
-- ==============================================================================

-- + hjkl: Swap window in direction
hs.hotkey.bind({"option", "ctrl"}, "h", function()
    yabai({"-m", "window", "--swap", "west"})
end)

hs.hotkey.bind({"option", "ctrl"}, "j", function()
    yabai({"-m", "window", "--swap", "south"})
end)

hs.hotkey.bind({"option", "ctrl"}, "k", function()
    yabai({"-m", "window", "--swap", "north"})
end)

hs.hotkey.bind({"option", "ctrl"}, "l", function()
    yabai({"-m", "window", "--swap", "east"})
end)

-- + r: Rotate layout
hs.hotkey.bind({"option", "ctrl"}, "r", function()
    yabai({"-m", "space", "--rotate", "270"})
end)

-- + y/x: Mirror layout
hs.hotkey.bind({"option", "ctrl"}, "y", function()
    yabai({"-m", "space", "--mirror", "y-axis"})
end)

hs.hotkey.bind({"option", "ctrl"}, "x", function()
    yabai({"-m", "space", "--mirror", "x-axis"})
end)


-- + p/n: Move window to prev/next space
hs.hotkey.bind({"option", "ctrl"}, "p", function()
    yabai({"-m", "window", "--space", "prev"})
end)

hs.hotkey.bind({"option", "ctrl"}, "n", function()
    yabai({"-m", "window", "--space", "next"})
end)

-- + 1/2/3: Move window to specific space
hs.hotkey.bind({"option", "ctrl"}, "1", function()
    yabai({"-m", "window", "--space", "1"})
end)

hs.hotkey.bind({"option", "ctrl"}, "2", function()
    yabai({"-m", "window", "--space", "2"})
end)

hs.hotkey.bind({"option", "ctrl"}, "3", function()
    yabai({"-m", "window", "--space", "3"})
end)


-- ---------------------------------------------
-- Cmd + Ctrl + F Full Screen Default MacOS Shortcut
-- ---------------------------------------------
-- When not overriding this shortcut with hammerspoon, 
-- you should override it with karabiner with the below code
--
-- ```
--            "complex_modifications": {
--                "rules": [
--                    {
--                        "description": "Disable Cmd+Ctrl+F (macOS fullscreen)",
--                        "manipulators": [
--                            {
--                                "type": "basic",
--                                "from": {
--                                    "key_code": "f",
--                                    "modifiers": {
--                                        "mandatory": ["command", "control"],
--                                        "optional": ["any"]
--                                    }
--                                },
--                                "to": []
--                            }
--                        ]
--                    }
--                ]
--            }
-- ```



