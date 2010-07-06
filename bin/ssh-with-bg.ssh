#!/bin/bash

# when you SSH in iTerm.app put host name and IP address in bg 
# adapted from http://kpumuk.info/mac-os-x/how-to-show-ssh-host-name-on-the-iterms-background

source "$HOME/.dotfiles/lib/lib-iterm.sh"

# First, check to see if we have the correct terminal!
if [ '' == $(iterm_ok) ] ; then
	/usr/bin/ssh "$@"
	exit $?
fi

HOSTNAME=`echo $@ | sed -e "s/.*@//" -e "s/ .*//"`
# RESOLVED_HOSTNAME=`nslookup $HOSTNAME|tail -n +4|grep '^Name:'|cut -f2 -d $'\t'`
# RESOLVED_IP=`nslookup $HOSTNAME|tail -n +4|grep '^Address:'|cut -f2 -d $':'|tail -c +2`
output=`dscacheutil -q host -a name $HOSTNAME`
RESOLVED_HOSTNAME=`echo -e "$output"|grep '^name:'|awk '{print $2}'`
RESOLVED_IP=`echo -e "$output"|grep '^ip_address:'|awk '{print $2}'`

text1=${RESOLVED_HOSTNAME:-HOSTNAME}
text2=${RESOLVED_IP:-}

# echo $(iterm_dimensions_set $WIDTH_NARROW $HEIGHT_TALL)
path=$(iterm_bg_image_make $text1 $text2)
echo $(iterm_bg_image_set $path)

on_exit () {
	iterm_bg_image_set $(iterm_bg_image_empty);
	$(iterm_bg_image_delete);
}
trap on_exit EXIT

/usr/bin/ssh "$@"