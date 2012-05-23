#!/bin/zsh
[ ! -f ~/.dirs ] && touch ~/.dirs
save (){
 command sed "/!$/d" ~/.dirs > ~/.dirs1; \mv ~/.dirs1 ~/.dirs; echo "$@"=\"`pwd`\" >> ~/.dirs; source ~/.dirs ;
}
source ~/.dirs
setopt cdablevars
