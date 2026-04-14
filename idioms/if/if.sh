##################################
#idioms
[[ -n "$DIR" ]] && cd "$DIR"

# same thing
if [[ -n "$DIR" ]]; then
  cd "$DIR"
fi

# same thing
if [[ "$DIR" ]]; then
  cd "$DIR"
fi

##################################

#idioms
[[ -z "$DIR" ]] || cd "$DIR"

# same thing
if [[ -z "$DIR" ]]; then
  :
else
  cd "$DIR"
fi

##################################

cd /tmp || { echo "cd to /tmp failed." ; exit ; }

##################################

[ -n "$DIR" ] && [ -d "$DIR" ] && cd "$DIR" || exit 4

##################################