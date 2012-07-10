add="$HOME/bin"
parts=(${(s~:~)PATH})
if [[ -z $parts[(r)$add] ]] ; then
  export PATH="$add:$PATH"
  # fix for that pbcopy mess
fi

which=$(which tmx)
parts=(${(s:/:)which})
found=$parts[(r)bleed*]
if [[ -z "$found" ]] ; then
  echo "    - make tmx bleed"
  eval $(tmx bleed)
else
  echo "    - bleeding already? skipping."
fi

