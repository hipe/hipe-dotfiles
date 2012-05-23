#!/bin/zsh

# I got the following from, and mod'd it: http://www.macosxhints.com/article.php?story=20020716005123797
#    The following aliases (save & show) are for saving frequently used directories
#    You can save a directory using an abbreviation of your choosing. Eg. save ms
#    You can subsequently move to one of the saved directories by using cd with
#    the abbreviation you chose. Eg. cd ms  (Note that no '$' is necessary.)

if [ ! -f ~/.dirs ]; then
  touch ~/.dirs
fi

save () {
  command sed "/!$/d" ~/.dirs | sort > ~/.dirs1
  \mv ~/.dirs1 ~/.dirs
  echo "$@"=\"`pwd`\" >> ~/.dirs
  source ~/.dirs
}
source ~/.dirs  # Initialization for the above 'save' facility: source the .sdirs file

