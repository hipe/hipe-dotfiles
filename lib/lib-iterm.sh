#!/bin/bash

function set_bg_color {
  local tty=$(tty)
  osascript -e "
		tell application \"iTerm\"
			repeat with theTerminal in terminals
				tell theTerminal
					try
						tell session id \"$tty\"
							set background image path to \"\"
							set background color to \"$1\"
						end tell
						on error errmesg number errn
					end try
				end tell
			end repeat
		end tell"
}

# set_bg "/tmp/iTermBG.tmp.png"
echo "setting to $1"
set_bg_color $1