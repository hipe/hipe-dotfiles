here="$0"

# workaround gnu/bsd platform asymmetries of readlink
my_readlink () {
  x=$(readlink --version 2>&1)
  _arg=$1
  if [[ "$x" == *illegal\ option\ --* ]] ; then # the BSD version of readlink
    file=$(readlink $_arg)
    if [[ -z "$file" ]] ; then # it was not a symlink
      file="$_arg"
    fi
  else
    file=$(readlink -f $_arg)
  fi
  echo "$file"
}

active='untouched'

_init_vars () {
  __file__=$(my_readlink "$here")
  if [[ -z "$__file__" ]] ; then
    echo "failed to determine absolute filepath of this file!"
    return
  fi
  my_dirname=$(dirname "$__file__")
  me=$(basename $my_dirname) # e.g. "hipe-dotfiles"
  active="$my_dirname/lib/$me/plugins/active"
}

_run () {
  _init_vars
  if [[ -n "$ok" ]]; then
    echo "$me: fatal: failed to _init_vars(): ->$ok<-"
  elif [[ -z "$active" ]] ; then
    echo "$me: fatal: failed to initialize active variable: -->$active<--"
  elif [ ! -d "$active" ] ; then
    echo "$me: fatal: active sub-plugins dir not found: -->$active<--"
  else
    _lines=$(find "$active" -maxdepth 1 -name '*.zsh')
    if [[ -z "$_lines" ]] ; then
      echo "$me: notice: no active plugins at all in $active"
    else
      echo "- $me"
      echo "$_lines" | sort | while read -r line ; do
        echo "  - $(basename $line)"
        source "$line"
      done
    fi
  fi
}

_run
