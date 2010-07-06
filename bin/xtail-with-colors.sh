#!/bin/bash


function set_bg {
	echo "running thing"
  local tty=$(tty)
  osascript -e "
  tell application \"iTerm\"
    repeat with theTerminal in terminals
      tell theTerminal
        try
          tell session id \"$tty\"
            set background color to \"blue\"
          end tell
          on error errmesg number errn
        end try
      end tell
    end repeat
  end tell"
}
echo "running..."
set_bg
