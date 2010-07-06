#!/bin/bash

# adapted from http://kpumuk.info/mac-os-x/how-to-show-ssh-host-name-on-the-iterms-background/

function iterm_dimensions_get {
  local size=( $(osascript -e "tell application \"iTerm\"
		get bounds of window 1
		end tell" | tr ',' ' ')
	)
  local x1=${size[0]} y1=${size[1]} x2=${size[2]} y2=${size[3]}
  # 15px - scrollbar width
  local w=$(( $x2 - $x1 - 15 ))
  # 44px - titlebar + tabs height
  local h=$(( $y2 - $y1 - 44))
  echo "${w}x${h}"
}


function iterm_bg_image_set {
	local tty=$(tty)
	osascript -e "
		tell application \"iTerm\"
			repeat with theTerminal in terminals
				tell theTerminal
					try
						tell session id \"$tty\"
							set background image path to \"$1\"
						end tell
						on error errmesg number errn
					end try
				end tell
			end repeat
		end tell
	"
}


function iterm_bg_color_set {
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
		end tell
	"
}

echo "here are dimensions:"
echo $(iterm_dimensions_get)
# echo "setting bgcolor to to $1"
# iterm_bg_color_set $1
iterm_bg_image_set "/tmp/iTermBG.tmp.png"