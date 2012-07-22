# per https://github.com/sstephenson/rbenv
#

add="$HOME/.rbenv/bin"
parts=(${(s~:~)PATH})
found=$parts[(r)$add]

if [[ -z $found ]] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
else
  echo "    - mutated path already? skipping."
fi


add2='*.rbenv/shims'
found2=$parts[(r)$add2]

if [[ -z $found2 ]] ; then
  echo "    - shimming"
  eval "$(rbenv init -)"
else
  echo "    - shimmed rbenv already? skipping"
fi
