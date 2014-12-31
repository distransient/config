-- Standard awesome library
require("awful") 
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful") 
-- Load menu entries
require("debian.menu") 

-- Handle startup errors
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end
-- Handle runtime errors
do
  local in_error = false
  awesome.add_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = err })
    in_error = false
  end)
end

-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/theme.lua")

terminal = "x-terminal-emulator" -- Get default terminal emulator
-- lil pop up menu
mainmenu = awful.menu({ items = { 
  { "wm", { { "restart", awesome.restart }, { "exit", awesome.quit } } },
  { "sys", debian.menu.Debian_menu.Debian },
  { "shell", terminal }
}})
layouts = { awful.layout.suit.tile, awful.layout.suit.max }
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end

-- Global mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () mainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

-- Global key bindings
modkey = "Mod4"
root.keys(awful.util.table.join(
  awful.key({ modkey }, "j", function () awful.client.focus.byidx( 1) 
    if client.focus then client.focus:raise() end end),
  awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1) 
    if client.focus then client.focus:raise() end end),
  awful.key({ modkey, "Shift" }, "j", function () 
    awful.client.swap.byidx( 1) end),
  awful.key({ modkey, "Shift" }, "k", function () 
    awful.client.swap.byidx(-1) end),
  awful.key({ modkey, "Control" }, "j", function () 
    awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Control" }, "k", function () 
    awful.screen.focus_relative(-1) end),
  awful.key({ modkey }, "l", function () awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end),
  awful.key({ modkey, "Shift" }, "h", function () 
    awful.tag.incnmaster( 1) end),
  awful.key({ modkey, "Shift" }, "l", function () 
    awful.tag.incnmaster(-1) end),
  awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1) end),
  awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
  awful.key({ modkey }, "Tab", function () 
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end end),
  awful.key({ modkey }, "c", function () mainmenu:show({keygrabber=true}) end),
  awful.key({ modkey }, "Return", function () awful.util.spawn(terminal) end),
  awful.key({ modkey, "Shift" }, "r", awesome.restart),
  awful.key({ modkey, "Shift" }, "q", awesome.quit),
  awful.key({ modkey }, "Escape", function () 
    awful.util.spawn("xscreensaver-command -lock") end),
  awful.key({ modkey }, "space", function () 
    awful.layout.inc(layouts, 1) end)
))

-- Window specific bindings and rules
awful.rules.rules = {{ rule = { }, properties = { focus = true,
  border_width = beautiful.border_width, border_color = beautiful.border_normal,
  keys = awful.util.table.join(
    awful.key({ modkey }, "x", function (c) c:kill() end),
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end)
  ),
  buttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c 
      c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
  )
}}}

-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup) 
  c:add_signal("mouse::enter", function(c) 
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier 
      and awful.client.focus.filter(c) then client.focus = c
    end 
  end) 
  if not startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)
  end
end)

-- Colorify the SHIT out of window borders
client.add_signal("focus", function(c) 
  c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) 
  c.border_color = beautiful.border_normal end)

awful.util.spawn("xscreensaver -nosplash")
awful.util.spawn(terminal)
