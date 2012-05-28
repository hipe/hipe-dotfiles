export PATH="$PATH:/usr/local/git/bin"

function gitignore {
  local file='.gitignore'
  if [[ ! -f $file ]] ; then
    echo "not found: $file"
    return 0
  fi
  cat $file | sort > tmp.tmp
  mv tmp.tmp .gitignore
  echo "resorted $file."
}
