if ! command_exists pygmentize; then
  # Do not overwrite the function
  return 0
fi

##
# Colored cat
function cat() {
  local out colored
  out=$(/bin/cat $@)
  colored=$(echo $out | pygmentize -f console -g 2>/dev/null)
  [[ -n $colored ]] && echo "$colored" || echo "$out"
}
