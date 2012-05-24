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

xyzzy='untouched'

_init_vars () {
  __file__=$(my_readlink "$here")
  if [[ -z "$__file__" ]] ; then
    echo "failed to determine absolute filepath of this file!"
    return
  fi
  echo "yes this is __file__:-->$__file__<--"
  my_dirname=$(dirname "$__file__")
  echo "yes this is my_dirname:-->$my_dirname<--"
  me=$(basename $my_dirname) # e.g. "hipe-dotfiles"
  xyzzy="$my_dirname/lib/$me/plugins/active"
}

_run () {
  _init_vars
  if [[ -n "$ok" ]]; then
    echo "$me: fatal: failed to _init_vars(): ->$ok<-"
  elif [[ -z "$xyzzy" ]] ; then
    echo "$me: fatal: failed to initialize xyzzy variable: -->$xyzzy<--"
  elif [ ! -d "$xyzzy" ] ; then
    echo "$me: fatal: active sub-plugins dir not found: -->$xyzzy<--"
  else
    _lines=$(find "$xyzzy" -maxdepth 1 -name '*.zsh')
    if [[ -z "$_lines" ]] ; then
      echo "$me: notice: no active plugins at all in $xyzzy"
    else
      echo "$_lines" | sort | while read -r line ; do
        echo "  * $me loading $(basename $line)"
        source "$line"
      done
    fi
  fi
}

_run
