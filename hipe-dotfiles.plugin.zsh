#!/bin/zsh

# workaround gnu/bsd platform asymmetries of readlink
my_readlink () {
  x=$(readlink --version 2>&1)
  if [[ "$x" == *illegal\ option\ --* ]] ; then # the BSD version of readlink
    file=$(readlink $1)
  else
    file=$(readlink -f $1)
  fi
  echo "$file"
}


here="$0"
full_here=$(my_readlink $here)
my_dirname=$(dirname $full_here)
me=$(basename $my_dirname) # e.g. "hipe-dotfiles"
plugins_dir="$my_dirname/lib/$me/plugins"

if [ ! -d "$plugins_dir" ] ; then
  echo "$me: strange: sub-plugins dir not found: $plugins_dir"
else
  find "$plugins_dir" -maxdepth 1 -name '*.zsh' | sort | while read -r line ; do
    echo "  * $me loading $(basename $line)"
    source "$line"
  done
fi
