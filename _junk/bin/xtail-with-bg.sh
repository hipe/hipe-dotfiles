#!/bin/bash

# when you use xtail, change the window dimensions and write something in the bg

source "$HOME/.dotfiles/lib/lib-iterm.sh"
# echo  "tty:$(tty)"
# echo "tp:$TERM_PROGRAM"
# echo "doing it: "
# echo "ok: ----$(iterm_ok)---"
# exit

# First, check to see if we have the correct terminal!
# there is a hack here so we can sudo the command.  TERM_PROGRAM doesn't get pickd up when we sudo.
if [[ "$(tty)" == 'not a tty' ]] || [[ 'root' != "$LOGNAME" && "$TERM_PROGRAM" != "iTerm.app" ]] ; then
	/opt/local/bin/xtail "$@"
	exit $?
fi

text1="xtail"
text2="$@"

echo $(iterm_dimensions_set $WIDTH_NARROW $HEIGHT_TALL)
path=$(iterm_bg_image_make "$text1" "$text2")
echo $(iterm_bg_image_set $path)

on_exit () {
	iterm_bg_image_set $(iterm_bg_image_empty);
	$(iterm_bg_image_delete);
}
trap on_exit EXIT

/opt/local/bin/xtail "$@"
