#!/bin/bash
# non-destructive install script for hipe-dotfiles
# you just have to trust it


# exit codes
E_WRONGARGS=85  # Non-numerical argument (bad argument format).
OK=0

p(){ printf "$1\n" >&2; }

shorthelp(){
  usage; p
  printf "See \"%s help\" for more help." $(basename $0)
}

usage(){
  printf "Usage: %s COMMAND [OPTS] [ARGS] \n" $(basename $0) >&2;
}

help(){
  usage; p
  p "Commands:"
  p "  install       non-destructively checks if it can non-destructively install"
}

invoke(){
  case "$1" in
  "")        shorthelp;          return $OK;;
  "help")    help;               return $OK;;
  "install") resp=install "$@";  return $resp;;
  *)
    p "Unrecognized command \"$@\""
    shorthelp
    return $E_WRONGARGS;;
  esac
}

install_help(){
  p "Usage: $(basename $0) install (-y)"
  p
  p "Options:"
  p "  -y      if not present, will just do a dry-run"
  return $OK
}

install(){
  local is_dry=1
  while getopts "yh" flag
  do case "$flag" in
    y) is_dry=0
       ;;
    h) return $(install_help)
       ;;
    ?)
      return $(install_help)
      ;;
  esac
  done

  local list=(foo.txt bar.txt)
  local file=  # no effect i think
  for file in ${list[@]:0}
  do
    local home_file="$HOME/$file"
    if [[ -f "$home_file" ]]
    then
      p "exists: $home_file. skipping."
    else
      do_file "$home_file" "$file" is_dry
    fi
  done

  if [ 1 = $is_dry ]
  then
    p "done with dry run install.  run with -y to install."
  else
    p "done with install."
  fi
}

do_file(){
  local home_file=$1
  local file=$2
  local is_dry=$3
  if [ "0" == "$is_dry" ]
  then
    echo "cp $file $home_file"
  else
    cp $file $home_file
  fi
}



invoke "$@"

p
p 'done'
exit $OK