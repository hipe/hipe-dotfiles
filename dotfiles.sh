#!/bin/bash
# non-destructive install script for hipe-dotfiles
# you just have to trust it


# exit codes
E_WRONGARGS=85  # Non-numerical argument (bad argument format).
OK=0
DOTFILES=(.bash_profile .bashrc .bash-aliases bin/seddit bin/lookat)
MY_SRC_DIR="$HOME/.dotfiles/src"

p(){ printf "$1\n" >&2; }

version(){
  echo "hipe-dotfiles version 0.0.0"
}

shorthelp(){
  usage; p
  printf "See \"%s -h\" for available commands." $(basename $0)
}

usage(){
  printf "Usage: %s COMMAND [OPTS] [ARGS] \n" $(basename $0) >&2;
}

help(){
  usage; p
  p "Commands:"
  p "  install       non-destructively check if it can non-destructively install"
  p "  pull          bring the existing files back into this project"
  p
  p "try -h after a command for more information."
}

invoke(){
  case "$1" in
  "")        shorthelp;          return $OK;;
  "-v")      version;            return $OK;;
  "version") version;            return $OK;;
  "-h")      help;               return $OK;;
  "help")    help;               return $OK;;
  "install") resp=install "$@";  return $resp;;
  "pull")    resp=pull "$@";     return $resp;;
  *)
    p "Unrecognized command \"$@\""
    shorthelp
    return $E_WRONGARGS;;
  esac
}

install_help(){
  p "Will do a dry run showing you what it would install."
  p
  p "Usage: $(basename $0) install [-y]"
  p
  p "Options:"
  p "  -y      if present, will actually install the files."
  return $OK
}

install(){
  local for_real="0"
  while getopts "yh" flag
  do case "$flag" in
    y) for_real="1";;
    h) return $(install_help) ;;
    ?) return $(install_help) ;;
  esac
  done

  if [[ "" != $@ && "-y" != $@ ]] ; then
    p "unexpected arg: $@"
    return $(install_help)
  fi

  local file=  # no effect i think
  for file in ${DOTFILES[@]:0}
  do
    local src_file="$MY_SRC_DIR/$file"
    local home_file="$HOME/$file"
    install_file "$src_file" "$home_file" $for_real
  done

  if [[ "1" == $for_real ]]
  then
    p "done with install."
  else
    p "done with dry run install.  run with -y to install."
  fi
}

install_file(){
  local src_file=$1
  local tgt_file=$2
  local for_real=$3
  local do_it="0"

  if [[ -f  "$tgt_file" ]] ; then
    if [[ "" == $(diff "$src_file" "$tgt_file") ]] ; then
      msg="(nodiff,skip)"
    else
      msg="(existsWithDiff,Skip)"
    fi
  elif [[ "1"=="$for_real" ]] ; then
    msg="(doinit)"
    do_it="1"
  else
    msg="(doitdry)"
  fi
  printf "cp %-42s %-25s %-10s\n" $src_file $tgt_file $msg
  if [[ "1" == "$do_it" ]] ; then
    `cp $src_file $tgt_file`
  fi
}

pull_help(){
  p "Will do a dry run showing files from your home directory"
  p "(or thereabouts) that it will copy into this project"
  p
  p "Usage: $(basename $0) pull [-y]"
  p
  p "Options:"
  p "  -y      if present, will actually pull the files."
  return $OK
}

pull(){
  local for_real="0"
  while getopts "yh" flag
  do case "$flag" in
    y) for_real="1" ;;
    h) return $(pull_help) ;;
    ?) return $(pull_help) ;;
  esac
  done

  if [[ "" != $@ && "-y" != $@ ]] ; then
    p "unexpected arg: $@"
    return $(pull_help)
  fi

  local strange=0
  local not_strange=0
  local file=  # no effect i think
  for file in ${DOTFILES[@]:0}
  do
    local home_file="$HOME/$file"
    local tgt_file="$MY_SRC_DIR/$file"
    if [[ ! -f "$home_file" ]] ; then
      p "not exists: $home_file. skipping."
    elif [[ ! -f "$tgt_file" ]] ; then
      p "strange -- skipping for nonexitent target file: $tgt_file"
      strange=1
    else
      do_pull_file "$home_file" "$tgt_file" $for_real
      not_strange=1
    fi
  done

  if [[ "1" == $strange ]] ; then
    p "if target files don't exist maybe you are running a symbolic link?"
  fi

  if [[ "0" == "$for_real" ]]
  then
    if [[ "1" == $not_strange ]] ; then
      p "done with dry run pull.  run with -y to pull."
    else
      p "done with dry run pull."
    fi
  else
    p "done with pull."
  fi
}

do_pull_file(){
  home_file=$1
  tgt_file=$2
  for_real=$3

  if [[ "" == $(diff "$home_file" "$tgt_file") ]] ; then
    msg="(same)"
    do_it="0"
  else
    if [[ "1" == "$for_real" ]] ; then
      msg="(real)"
      do_it="1"
    else
      msg="(dry)"
      do_it="0"
    fi
  fi
  printf "cp %-26s %-42s %s\n" $home_file $tgt_file $msg
  if [[ "1" == "$do_it" ]] ; then
    `cp $home_file $tgt_file`
  fi
}


invoke "$@"

p
p 'done'
exit $OK