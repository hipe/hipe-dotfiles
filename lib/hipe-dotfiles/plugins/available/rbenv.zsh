# per https://github.com/sstephenson/rbenv
#

add="$HOME/.rbenv/bin"
parts=(${(s~:~)PATH})
found=$parts[(r)$add]

if [[ -z $parts[(r)$add] ]] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
else
  echo "    - mutated path already? skipping."
fi

which=$(which ruby)
if [[ '/usr/bin/ruby' == "$which" ]] ; then
  eval "$(rbenv init -)"
else
  echo "    - ruby is $which? skipping."
fi
